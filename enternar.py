import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error
import xgboost as xgb
import matplotlib.pyplot as plt
import seaborn as sns
import joblib
import warnings
warnings.filterwarnings('ignore')

class XGBoostTrainer:
    def __init__(self, task_type='classification'):
        """
        Inicializar el entrenador XGBoost
        
        Parameters:
        task_type (str): 'classification' o 'regression'
        """
        self.task_type = task_type
        self.model = None
        self.scaler = StandardScaler()
        self.label_encoders = {}
        self.feature_importance = None
        
    def load_data(self, file_path, target_column):
        """
        Cargar datos desde archivo CSV
        
        Parameters:
        file_path (str): Ruta del archivo CSV
        target_column (str): Nombre de la columna objetivo
        """
        try:
            self.data = pd.read_csv(file_path)
            self.target_column = target_column
            print(f"Datos cargados exitosamente: {self.data.shape}")
            print(f"Columnas: {list(self.data.columns)}")
            return True
        except Exception as e:
            print(f"Error al cargar datos: {e}")
            return False
    
    def explore_data(self):
        """Exploración básica de los datos"""
        print("\n=== EXPLORACIÓN DE DATOS ===")
        print(f"Shape: {self.data.shape}")
        print(f"\nTipos de datos:\n{self.data.dtypes}")
        print(f"\nValores nulos:\n{self.data.isnull().sum()}")
        print(f"\nEstadísticas descriptivas:\n{self.data.describe()}")
        
        if self.task_type == 'classification':
            print(f"\nDistribución de clases:\n{self.data[self.target_column].value_counts()}")
    
    def preprocess_data(self):
        """Preprocesamiento de datos"""
        print("\n=== PREPROCESAMIENTO ===")
        
        # Separar características y variable objetivo
        X = self.data.drop(columns=[self.target_column])
        y = self.data[self.target_column]
        
        # Manejar valores nulos
        X = X.fillna(X.median() if X.select_dtypes(include=[np.number]).shape[1] > 0 else X.mode().iloc[0])
        
        # Codificar variables categóricas
        categorical_columns = X.select_dtypes(include=['object']).columns
        for col in categorical_columns:
            le = LabelEncoder()
            X[col] = le.fit_transform(X[col].astype(str))
            self.label_encoders[col] = le
        
        # Codificar variable objetivo si es clasificación
        if self.task_type == 'classification' and y.dtype == 'object':
            le_target = LabelEncoder()
            y = le_target.fit_transform(y)
            self.target_encoder = le_target
        
        # Dividir datos
        self.X_train, self.X_test, self.y_train, self.y_test = train_test_split(
            X, y, test_size=0.2, random_state=42, stratify=y if self.task_type == 'classification' else None
        )
        
        # Escalar características (opcional para XGBoost, pero puede ayudar)
        self.X_train_scaled = self.scaler.fit_transform(self.X_train)
        self.X_test_scaled = self.scaler.transform(self.X_test)
        
        print(f"Datos de entrenamiento: {self.X_train.shape}")
        print(f"Datos de prueba: {self.X_test.shape}")
        
        return self.X_train, self.X_test, self.y_train, self.y_test
    
    def train_model(self, use_grid_search=True, custom_params=None):
        """
        Entrenar modelo XGBoost
        
        Parameters:
        use_grid_search (bool): Si usar búsqueda de hiperparámetros
        custom_params (dict): Parámetros personalizados
        """
        print("\n=== ENTRENAMIENTO DEL MODELO ===")
        
        if custom_params:
            params = custom_params
        else:
            # Parámetros base según el tipo de tarea
            if self.task_type == 'classification':
                params = {
                    'objective': 'multi:softprob' if len(np.unique(self.y_train)) > 2 else 'binary:logistic',
                    'eval_metric': 'mlogloss' if len(np.unique(self.y_train)) > 2 else 'logloss',
                    'max_depth': 6,
                    'learning_rate': 0.1,
                    'n_estimators': 100,
                    'subsample': 0.8,
                    'colsample_bytree': 0.8,
                    'random_state': 42
                }
            else:
                params = {
                    'objective': 'reg:squarederror',
                    'eval_metric': 'rmse',
                    'max_depth': 6,
                    'learning_rate': 0.1,
                    'n_estimators': 100,
                    'subsample': 0.8,
                    'colsample_bytree': 0.8,
                    'random_state': 42
                }
        
        if use_grid_search:
            print("Realizando búsqueda de hiperparámetros...")
            param_grid = {
                'max_depth': [3, 6, 9],
                'learning_rate': [0.01, 0.1, 0.2],
                'n_estimators': [100, 200, 300],
                'subsample': [0.8, 0.9, 1.0]
            }
            
            if self.task_type == 'classification':
                self.model = xgb.XGBClassifier(**{k: v for k, v in params.items() if k not in param_grid})
                scoring = 'accuracy'
            else:
                self.model = xgb.XGBRegressor(**{k: v for k, v in params.items() if k not in param_grid})
                scoring = 'neg_mean_squared_error'
            
            grid_search = GridSearchCV(
                self.model, param_grid, cv=5, scoring=scoring, n_jobs=-1, verbose=1
            )
            grid_search.fit(self.X_train, self.y_train)
            
            self.model = grid_search.best_estimator_
            print(f"Mejores parámetros: {grid_search.best_params_}")
            print(f"Mejor score CV: {grid_search.best_score_:.4f}")
        
        else:
            if self.task_type == 'classification':
                self.model = xgb.XGBClassifier(**params)
            else:
                self.model = xgb.XGBRegressor(**params)
            
            self.model.fit(self.X_train, self.y_train)
        
        # Obtener importancia de características
        self.feature_importance = pd.DataFrame({
            'feature': self.X_train.columns,
            'importance': self.model.feature_importances_
        }).sort_values('importance', ascending=False)
        
        print("Modelo entrenado exitosamente!")
        return self.model
    
    def evaluate_model(self):
        """Evaluar el modelo"""
        print("\n=== EVALUACIÓN DEL MODELO ===")
        
        # Predicciones
        y_pred_train = self.model.predict(self.X_train)
        y_pred_test = self.model.predict(self.X_test)
        
        if self.task_type == 'classification':
            # Métricas de clasificación
            train_acc = accuracy_score(self.y_train, y_pred_train)
            test_acc = accuracy_score(self.y_test, y_pred_test)
            
            print(f"Accuracy Entrenamiento: {train_acc:.4f}")
            print(f"Accuracy Prueba: {test_acc:.4f}")
            
            print(f"\nReporte de clasificación (Prueba):")
            print(classification_report(self.y_test, y_pred_test))
            
            # Validación cruzada
            cv_scores = cross_val_score(self.model, self.X_train, self.y_train, cv=5, scoring='accuracy')
            print(f"\nValidación Cruzada - Accuracy: {cv_scores.mean():.4f} (+/- {cv_scores.std() * 2:.4f})")
            
        else:
            # Métricas de regresión
            train_mse = mean_squared_error(self.y_train, y_pred_train)
            test_mse = mean_squared_error(self.y_test, y_pred_test)
            train_r2 = r2_score(self.y_train, y_pred_train)
            test_r2 = r2_score(self.y_test, y_pred_test)
            test_mae = mean_absolute_error(self.y_test, y_pred_test)
            
            print(f"MSE Entrenamiento: {train_mse:.4f}")
            print(f"MSE Prueba: {test_mse:.4f}")
            print(f"RMSE Prueba: {np.sqrt(test_mse):.4f}")
            print(f"R² Entrenamiento: {train_r2:.4f}")
            print(f"R² Prueba: {test_r2:.4f}")
            print(f"MAE Prueba: {test_mae:.4f}")
            
            # Validación cruzada
            cv_scores = cross_val_score(self.model, self.X_train, self.y_train, cv=5, scoring='neg_mean_squared_error')
            print(f"\nValidación Cruzada - RMSE: {np.sqrt(-cv_scores.mean()):.4f} (+/- {np.sqrt(cv_scores.std() * 2):.4f})")
    
    def plot_results(self):
        """Generar gráficos de resultados"""
        plt.figure(figsize=(15, 10))
        
        # Importancia de características
        plt.subplot(2, 2, 1)
        top_features = self.feature_importance.head(10)
        plt.barh(top_features['feature'], top_features['importance'])
        plt.title('Top 10 - Importancia de Características')
        plt.xlabel('Importancia')
        
        if self.task_type == 'classification':
            # Matriz de confusión
            plt.subplot(2, 2, 2)
            y_pred = self.model.predict(self.X_test)
            cm = confusion_matrix(self.y_test, y_pred)
            sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
            plt.title('Matriz de Confusión')
            plt.ylabel('Valor Real')
            plt.xlabel('Predicción')
        else:
            # Predicciones vs Valores Reales
            plt.subplot(2, 2, 2)
            y_pred = self.model.predict(self.X_test)
            plt.scatter(self.y_test, y_pred, alpha=0.6)
            plt.plot([self.y_test.min(), self.y_test.max()], [self.y_test.min(), self.y_test.max()], 'r--', lw=2)
            plt.xlabel('Valores Reales')
            plt.ylabel('Predicciones')
            plt.title('Predicciones vs Valores Reales')
        
        # Curva de aprendizaje (training loss)
        plt.subplot(2, 2, 3)
        results = self.model.evals_result() if hasattr(self.model, 'evals_result') else None
        if results:
            plt.plot(results['validation_0']['rmse'] if 'rmse' in results['validation_0'] else results['validation_0']['logloss'])
            plt.title('Curva de Aprendizaje')
            plt.xlabel('Iteraciones')
            plt.ylabel('Error')
        
        plt.tight_layout()
        plt.show()
    
    def save_model(self, filename='xgboost_model.pkl'):
        """Guardar el modelo entrenado"""
        if self.model is not None:
            joblib.dump({
                'model': self.model,
                'scaler': self.scaler,
                'label_encoders': self.label_encoders,
                'feature_importance': self.feature_importance,
                'task_type': self.task_type
            }, filename)
            print(f"Modelo guardado como: {filename}")
        else:
            print("No hay modelo entrenado para guardar")
    
    def load_model(self, filename='xgboost_model.pkl'):
        """Cargar modelo pre-entrenado"""
        try:
            loaded_data = joblib.load(filename)
            self.model = loaded_data['model']
            self.scaler = loaded_data['scaler']
            self.label_encoders = loaded_data['label_encoders']
            self.feature_importance = loaded_data['feature_importance']
            self.task_type = loaded_data['task_type']
            print(f"Modelo cargado desde: {filename}")
            return True
        except Exception as e:
            print(f"Error al cargar modelo: {e}")
            return False

# Ejemplo de uso
def main():
    # Crear instancia del entrenador
    trainer = XGBoostTrainer(task_type='classification')  # o 'regression'
    
    # Cargar datos (reemplaza con tu archivo)
    if trainer.load_data('tu_archivo.csv', 'target_column'):
        
        # Explorar datos
        trainer.explore_data()
        
        # Preprocesar datos
        trainer.preprocess_data()
        
        # Entrenar modelo
        trainer.train_model(use_grid_search=True)
        
        # Evaluar modelo
        trainer.evaluate_model()
        
        # Generar gráficos
        trainer.plot_results()
        
        # Guardar modelo
        trainer.save_model('mi_modelo_xgboost.pkl')

if __name__ == "__main__":
    main()