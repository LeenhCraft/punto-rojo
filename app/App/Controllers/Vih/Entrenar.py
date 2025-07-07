#!/usr/bin/env python3
"""
Entrenador XGBoost para Predicción de Casos VIH
Diseñado para predecir aumentos de casos por distrito/establecimiento
con manejo de errores para integración con PHP
"""

import pandas as pd
import numpy as np
import json
import sys
import os
import argparse
import warnings
from datetime import datetime, timedelta
from typing import Dict, List, Tuple, Optional, Any
import traceback

# Librerías de ML
import xgboost as xgb
from sklearn.model_selection import train_test_split, TimeSeriesSplit, GridSearchCV
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.ensemble import RandomForestRegressor
import joblib

# Librerías de visualización y análisis
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats

# Configuración
warnings.filterwarnings('ignore')
plt.style.use('default')

class VIHCasePredictor:
    """
    Predictor de casos VIH usando XGBoost
    Optimizado para predicción de aumentos por distrito/establecimiento
    """
    
    def __init__(self, config: Dict[str, Any] = None):
        """
        Inicializar el predictor
        
        Args:
            config: Configuración del modelo (opcional)
        """
        self.config = config or {}
        self.model = None
        self.scaler = StandardScaler()
        self.label_encoders = {}
        self.feature_importance = None
        self.training_history = {}
        self.prediction_intervals = {}
        self.alert_thresholds = {}
        
        # Configuración por defecto
        self.default_config = {
            'target_column': 'total_cuestionarios',
            'horizon_months': 3,
            'test_size': 0.2,
            'random_state': 42,
            'auto_optimize': True,
            'confidence_intervals': True,
            'alert_threshold_pct': 20,  # 20% de aumento para alerta
            'min_data_points': 6,  # Mínimo 6 meses de datos
            'validation_method': 'temporal',
            'interpretability_level': 'high'
        }
        
        # Combinar configuraciones
        self.config = {**self.default_config, **self.config}
    
    def load_data(self, file_path: str) -> Dict[str, Any]:
        """
        Cargar datos desde archivo CSV
        
        Args:
            file_path: Ruta del archivo CSV
            
        Returns:
            Dict con status y mensaje
        """
        try:
            if not os.path.exists(file_path):
                return {
                    'status': False,
                    'message': f'Archivo no encontrado: {file_path}',
                    'error_code': 'FILE_NOT_FOUND'
                }
            
            self.data = pd.read_csv(file_path)
            
            # Validaciones básicas
            if self.data.empty:
                return {
                    'status': False,
                    'message': 'El archivo CSV está vacío',
                    'error_code': 'EMPTY_FILE'
                }
            
            if len(self.data) < self.config['min_data_points']:
                return {
                    'status': False,
                    'message': f'Datos insuficientes. Mínimo {self.config["min_data_points"]} registros, encontrados {len(self.data)}',
                    'error_code': 'INSUFFICIENT_DATA'
                }
            
            # Verificar columna objetivo
            if self.config['target_column'] not in self.data.columns:
                return {
                    'status': False,
                    'message': f'Columna objetivo "{self.config["target_column"]}" no encontrada',
                    'error_code': 'TARGET_COLUMN_NOT_FOUND'
                }
            
            # Información del dataset
            data_info = {
                'total_records': len(self.data),
                'columns': list(self.data.columns),
                'districts': self.data['id_distrito'].nunique() if 'id_distrito' in self.data.columns else 0,
                'establishments': self.data['id_establecimiento'].nunique() if 'id_establecimiento' in self.data.columns else 0,
                'date_range': self._get_date_range(),
                'target_stats': self._get_target_stats()
            }
            
            return {
                'status': True,
                'message': 'Datos cargados exitosamente',
                'data_info': data_info
            }
            
        except Exception as e:
            return {
                'status': False,
                'message': f'Error al cargar datos: {str(e)}',
                'error_code': 'LOAD_ERROR',
                'traceback': traceback.format_exc()
            }
    
    def _get_date_range(self) -> Dict[str, str]:
        """Obtener rango de fechas del dataset"""
        try:
            if 'fecha_mes' in self.data.columns:
                dates = pd.to_datetime(self.data['fecha_mes'])
                return {
                    'start': dates.min().strftime('%Y-%m-%d'),
                    'end': dates.max().strftime('%Y-%m-%d'),
                    'months': len(dates.dt.to_period('M').unique())
                }
            return {'start': 'N/A', 'end': 'N/A', 'months': 0}
        except:
            return {'start': 'N/A', 'end': 'N/A', 'months': 0}
    
    def _get_target_stats(self) -> Dict[str, float]:
        """Obtener estadísticas de la variable objetivo"""
        try:
            target = self.data[self.config['target_column']]
            return {
                'mean': float(target.mean()),
                'std': float(target.std()),
                'min': float(target.min()),
                'max': float(target.max()),
                'total': float(target.sum())
            }
        except:
            return {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'total': 0}
    
    def preprocess_data(self) -> Dict[str, Any]:
        """
        Preprocesar datos para entrenamiento
        
        Returns:
            Dict con status y mensaje
        """
        try:
            # Crear copia de trabajo
            df = self.data.copy()
            
            # Convertir fechas si existe la columna
            if 'fecha_mes' in df.columns:
                df['fecha_mes'] = pd.to_datetime(df['fecha_mes'])
                df = df.sort_values(['id_distrito', 'id_establecimiento', 'fecha_mes'])
            
            # Identificar columnas categóricas y numéricas
            categorical_cols = df.select_dtypes(include=['object']).columns.tolist()
            numeric_cols = df.select_dtypes(include=[np.number]).columns.tolist()
            
            # Remover columnas de identificación del encoding
            id_cols = ['id_distrito', 'id_establecimiento', 'id_cuestionario', 'id_paciente']
            categorical_cols = [col for col in categorical_cols if col not in id_cols]
            
            # Encoding de variables categóricas
            for col in categorical_cols:
                if col in df.columns:
                    le = LabelEncoder()
                    df[col] = le.fit_transform(df[col].astype(str))
                    self.label_encoders[col] = le
            
            # Manejo de valores nulos
            df = df.fillna(df.median(numeric_only=True))
            
            # Crear features temporales adicionales si hay fechas
            if 'fecha_mes' in df.columns:
                df = self._create_temporal_features(df)
            
            # Preparar datos para entrenamiento
            self.processed_data = df
            
            # Separar características y variable objetivo
            feature_cols = [col for col in df.columns if col not in [
                self.config['target_column'], 'fecha_mes', 'nombre_distrito', 
                'nombre_establecimiento', 'distrito_codigo', 'codigo_establecimiento'
            ]]
            
            self.X = df[feature_cols]
            self.y = df[self.config['target_column']]
            
            # Información del preprocesamiento
            preprocessing_info = {
                'original_features': len(self.data.columns),
                'processed_features': len(feature_cols),
                'categorical_encoded': len(categorical_cols),
                'missing_values_filled': df.isnull().sum().sum(),
                'feature_columns': feature_cols
            }
            
            return {
                'status': True,
                'message': 'Preprocesamiento completado',
                'preprocessing_info': preprocessing_info
            }
            
        except Exception as e:
            return {
                'status': False,
                'message': f'Error en preprocesamiento: {str(e)}',
                'error_code': 'PREPROCESSING_ERROR',
                'traceback': traceback.format_exc()
            }
    
    def _create_temporal_features(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        Crear features temporales avanzadas
        
        Args:
            df: DataFrame con datos
            
        Returns:
            DataFrame con features temporales
        """
        # Ordenar por entidad y fecha
        df = df.sort_values(['id_distrito', 'id_establecimiento', 'fecha_mes'])
        
        # Features temporales básicas
        df['year'] = df['fecha_mes'].dt.year
        df['month'] = df['fecha_mes'].dt.month
        df['quarter'] = df['fecha_mes'].dt.quarter
        df['month_sin'] = np.sin(2 * np.pi * df['month'] / 12)
        df['month_cos'] = np.cos(2 * np.pi * df['month'] / 12)
        
        # Features por grupo (distrito + establecimiento)
        target_col = self.config['target_column']
        
        # Lags y diferencias
        for lag in [1, 2, 3]:
            df[f'{target_col}_lag_{lag}'] = df.groupby(['id_distrito', 'id_establecimiento'])[target_col].shift(lag)
            
        # Promedios móviles
        for window in [3, 6]:
            df[f'{target_col}_ma_{window}'] = df.groupby(['id_distrito', 'id_establecimiento'])[target_col].rolling(window=window, min_periods=1).mean().reset_index(0, drop=True)
        
        # Tendencias
        df[f'{target_col}_trend'] = df.groupby(['id_distrito', 'id_establecimiento'])[target_col].pct_change()
        df[f'{target_col}_volatility'] = df.groupby(['id_distrito', 'id_establecimiento'])[target_col].rolling(window=3, min_periods=1).std().reset_index(0, drop=True)
        
        # Llenar NaN resultantes
        df = df.fillna(method='bfill').fillna(0)
        
        return df
    
    def train_model(self, custom_params: Dict[str, Any] = None) -> Dict[str, Any]:
        """
        Entrenar modelo XGBoost
        
        Args:
            custom_params: Parámetros personalizados (opcional)
            
        Returns:
            Dict con status y resultados del entrenamiento
        """
        try:
            # Dividir datos según método de validación
            if self.config['validation_method'] == 'temporal':
                X_train, X_test, y_train, y_test = self._temporal_split()
            else:
                X_train, X_test, y_train, y_test = train_test_split(
                    self.X, self.y, 
                    test_size=self.config['test_size'],
                    random_state=self.config['random_state']
                )
            
            # Configurar parámetros del modelo
            if custom_params:
                params = custom_params
            elif self.config['auto_optimize']:
                params = self._optimize_hyperparameters(X_train, y_train)
            else:
                params = self._get_default_params()
            
            # Entrenar modelo principal
            self.model = xgb.XGBRegressor(**params)
            self.model.fit(X_train, y_train)
            
            # Evaluar modelo
            y_pred_train = self.model.predict(X_train)
            y_pred_test = self.model.predict(X_test)
            
            # Calcular métricas
            metrics = self._calculate_metrics(y_train, y_pred_train, y_test, y_pred_test)
            
            # Calcular importancia de características
            self.feature_importance = self._calculate_feature_importance()
            
            # Calcular intervalos de confianza si está habilitado
            if self.config['confidence_intervals']:
                self.prediction_intervals = self._calculate_prediction_intervals(X_test, y_test)
            
            # Configurar alertas
            self._setup_alert_system()
            
            # Guardar historial de entrenamiento
            self.training_history = {
                'timestamp': datetime.now().isoformat(),
                'config': self.config,
                'params': params,
                'metrics': metrics,
                'feature_count': len(self.X.columns),
                'training_samples': len(X_train),
                'test_samples': len(X_test)
            }
            
            return {
                'status': True,
                'message': 'Modelo entrenado exitosamente',
                'metrics': metrics,
                'feature_importance': self.feature_importance,
                'training_info': self.training_history
            }
            
        except Exception as e:
            return {
                'status': False,
                'message': f'Error en entrenamiento: {str(e)}',
                'error_code': 'TRAINING_ERROR',
                'traceback': traceback.format_exc()
            }
    
    def _temporal_split(self) -> Tuple[pd.DataFrame, pd.DataFrame, pd.Series, pd.Series]:
        """
        División temporal de datos (simula predicción real)
        
        Returns:
            Tuple con X_train, X_test, y_train, y_test
        """
        if 'fecha_mes' in self.processed_data.columns:
            # Ordenar por fecha
            df_sorted = self.processed_data.sort_values('fecha_mes')
            
            # Dividir: 80% para entrenamiento, 20% para prueba
            split_idx = int(len(df_sorted) * 0.8)
            
            train_data = df_sorted.iloc[:split_idx]
            test_data = df_sorted.iloc[split_idx:]
            
            # Obtener índices correspondientes
            train_idx = train_data.index
            test_idx = test_data.index
            
            return (
                self.X.loc[train_idx],
                self.X.loc[test_idx],
                self.y.loc[train_idx],
                self.y.loc[test_idx]
            )
        else:
            # Fallback a división aleatoria
            return train_test_split(
                self.X, self.y,
                test_size=self.config['test_size'],
                random_state=self.config['random_state']
            )
    
    def _optimize_hyperparameters(self, X_train: pd.DataFrame, y_train: pd.Series) -> Dict[str, Any]:
        """
        Optimizar hiperparámetros automáticamente
        
        Args:
            X_train: Datos de entrenamiento
            y_train: Variable objetivo de entrenamiento
            
        Returns:
            Dict con mejores parámetros
        """
        param_grid = {
            'max_depth': [3, 6, 9],
            'learning_rate': [0.01, 0.1, 0.2],
            'n_estimators': [100, 200, 300],
            'subsample': [0.8, 0.9, 1.0],
            'colsample_bytree': [0.8, 0.9, 1.0],
            'reg_alpha': [0, 0.1, 1],
            'reg_lambda': [0, 0.1, 1]
        }
        
        # Usar validación cruzada temporal si es posible
        if len(X_train) > 50:
            cv = TimeSeriesSplit(n_splits=3)
        else:
            cv = 3
        
        xgb_model = xgb.XGBRegressor(
            random_state=self.config['random_state'],
            objective='reg:squarederror'
        )
        
        grid_search = GridSearchCV(
            xgb_model,
            param_grid,
            cv=cv,
            scoring='neg_mean_squared_error',
            n_jobs=-1,
            verbose=0
        )
        
        grid_search.fit(X_train, y_train)
        
        return grid_search.best_params_
    
    def _get_default_params(self) -> Dict[str, Any]:
        """
        Obtener parámetros por defecto optimizados para casos VIH
        
        Returns:
            Dict con parámetros por defecto
        """
        return {
            'max_depth': 6,
            'learning_rate': 0.1,
            'n_estimators': 200,
            'subsample': 0.8,
            'colsample_bytree': 0.8,
            'reg_alpha': 0.1,
            'reg_lambda': 0.1,
            'random_state': self.config['random_state'],
            'objective': 'reg:squarederror',
            'eval_metric': 'rmse'
        }
    
    def _calculate_metrics(self, y_train: pd.Series, y_pred_train: np.ndarray, 
                          y_test: pd.Series, y_pred_test: np.ndarray) -> Dict[str, float]:
        """
        Calcular métricas de evaluación
        
        Args:
            y_train: Valores reales de entrenamiento
            y_pred_train: Predicciones de entrenamiento
            y_test: Valores reales de prueba
            y_pred_test: Predicciones de prueba
            
        Returns:
            Dict con métricas
        """
        return {
            'train_rmse': float(np.sqrt(mean_squared_error(y_train, y_pred_train))),
            'test_rmse': float(np.sqrt(mean_squared_error(y_test, y_pred_test))),
            'train_mae': float(mean_absolute_error(y_train, y_pred_train)),
            'test_mae': float(mean_absolute_error(y_test, y_pred_test)),
            'train_r2': float(r2_score(y_train, y_pred_train)),
            'test_r2': float(r2_score(y_test, y_pred_test)),
            'train_mape': float(self._calculate_mape(y_train, y_pred_train)),
            'test_mape': float(self._calculate_mape(y_test, y_pred_test))
        }
    
    def _calculate_mape(self, y_true: pd.Series, y_pred: np.ndarray) -> float:
        """
        Calcular Mean Absolute Percentage Error
        
        Args:
            y_true: Valores reales
            y_pred: Predicciones
            
        Returns:
            MAPE
        """
        y_true = np.array(y_true)
        y_pred = np.array(y_pred)
        
        # Evitar división por cero
        mask = y_true != 0
        if mask.sum() == 0:
            return 0.0
        
        return np.mean(np.abs((y_true[mask] - y_pred[mask]) / y_true[mask])) * 100
    
    def _calculate_feature_importance(self) -> List[Dict[str, Any]]:
        """
        Calcular importancia de características
        
        Returns:
            Lista con importancia de características
        """
        if self.model is None:
            return []
        
        importance_data = []
        feature_names = self.X.columns
        importance_scores = self.model.feature_importances_
        
        for name, score in zip(feature_names, importance_scores):
            importance_data.append({
                'feature': name,
                'importance': float(score),
                'importance_pct': float(score / importance_scores.sum() * 100)
            })
        
        # Ordenar por importancia
        importance_data.sort(key=lambda x: x['importance'], reverse=True)
        
        return importance_data
    
    def _calculate_prediction_intervals(self, X_test: pd.DataFrame, y_test: pd.Series) -> Dict[str, Any]:
        """
        Calcular intervalos de confianza usando quantile regression
        
        Args:
            X_test: Datos de prueba
            y_test: Variable objetivo de prueba
            
        Returns:
            Dict con información de intervalos
        """
        try:
            # Entrenar modelos para cuantiles
            quantiles = [0.025, 0.975]  # 95% de confianza
            quantile_models = {}
            
            for q in quantiles:
                model = xgb.XGBRegressor(
                    objective='reg:quantileerror',
                    quantile_alpha=q,
                    **self._get_default_params()
                )
                model.fit(self.X, self.y)
                quantile_models[q] = model
            
            # Predecir intervalos en datos de prueba
            predictions = self.model.predict(X_test)
            lower_bound = quantile_models[0.025].predict(X_test)
            upper_bound = quantile_models[0.975].predict(X_test)
            
            # Calcular cobertura
            coverage = np.mean((y_test >= lower_bound) & (y_test <= upper_bound))
            
            return {
                'enabled': True,
                'coverage': float(coverage),
                'mean_interval_width': float(np.mean(upper_bound - lower_bound)),
                'quantile_models': quantile_models
            }
            
        except Exception as e:
            return {
                'enabled': False,
                'error': str(e)
            }
    
    def _setup_alert_system(self) -> None:
        """
        Configurar sistema de alertas
        """
        # Calcular umbrales basados en datos históricos
        historical_values = self.y.values
        
        self.alert_thresholds = {
            'low': float(np.percentile(historical_values, 25)),
            'medium': float(np.percentile(historical_values, 75)),
            'high': float(np.percentile(historical_values, 90)),
            'critical': float(np.percentile(historical_values, 95)),
            'percentage_increase': self.config['alert_threshold_pct']
        }
    
    def predict_future(self, horizon_months: int = None, 
                      district_id: int = None, 
                      establishment_id: int = None) -> Dict[str, Any]:
        """
        Realizar predicciones futuras
        
        Args:
            horizon_months: Meses hacia el futuro
            district_id: ID de distrito específico (opcional)
            establishment_id: ID de establecimiento específico (opcional)
            
        Returns:
            Dict con predicciones y alertas
        """
        try:
            if self.model is None:
                return {
                    'status': False,
                    'message': 'Modelo no entrenado',
                    'error_code': 'MODEL_NOT_TRAINED'
                }
            
            horizon = horizon_months or self.config['horizon_months']
            
            # Filtrar datos si se especifican entidades
            prediction_data = self.processed_data.copy()
            
            if district_id:
                prediction_data = prediction_data[prediction_data['id_distrito'] == district_id]
            
            if establishment_id:
                prediction_data = prediction_data[prediction_data['id_establecimiento'] == establishment_id]
            
            if prediction_data.empty:
                return {
                    'status': False,
                    'message': 'No hay datos para las entidades especificadas',
                    'error_code': 'NO_DATA_FOR_ENTITIES'
                }
            
            # Generar predicciones
            predictions = self._generate_predictions(prediction_data, horizon)
            
            # Generar alertas
            alerts = self._generate_alerts(predictions)
            
            # Crear ranking de riesgo
            risk_ranking = self._create_risk_ranking(predictions)
            
            return {
                'status': True,
                'message': 'Predicciones generadas exitosamente',
                'predictions': predictions,
                'alerts': alerts,
                'risk_ranking': risk_ranking,
                'horizon_months': horizon,
                'prediction_date': datetime.now().isoformat()
            }
            
        except Exception as e:
            return {
                'status': False,
                'message': f'Error en predicción: {str(e)}',
                'error_code': 'PREDICTION_ERROR',
                'traceback': traceback.format_exc()
            }
    
    def _generate_predictions(self, data: pd.DataFrame, horizon: int) -> List[Dict[str, Any]]:
        """
        Generar predicciones para horizonte especificado
        
        Args:
            data: Datos base para predicción
            horizon: Meses hacia el futuro
            
        Returns:
            Lista con predicciones
        """
        predictions = []
        
        # Obtener última fecha disponible
        if 'fecha_mes' in data.columns:
            last_date = pd.to_datetime(data['fecha_mes']).max()
        else:
            last_date = pd.Timestamp.now()
        
        # Generar predicciones para cada mes futuro
        for month_ahead in range(1, horizon + 1):
            future_date = last_date + pd.DateOffset(months=month_ahead)
            
            # Preparar datos para predicción
            future_data = self._prepare_future_data(data, future_date, month_ahead)
            
            # Realizar predicción
            pred_values = self.model.predict(future_data)
            
            # Calcular intervalos de confianza si están disponibles
            if self.prediction_intervals.get('enabled', False):
                lower_bounds = self.prediction_intervals['quantile_models'][0.025].predict(future_data)
                upper_bounds = self.prediction_intervals['quantile_models'][0.975].predict(future_data)
            else:
                lower_bounds = pred_values * 0.8  # Estimación simple
                upper_bounds = pred_values * 1.2
            
            # Crear predicciones por entidad
            for idx, (_, row) in enumerate(future_data.iterrows()):
                pred_dict = {
                    'id_distrito': int(data.iloc[idx]['id_distrito']) if 'id_distrito' in data.columns else None,
                    'id_establecimiento': int(data.iloc[idx]['id_establecimiento']) if 'id_establecimiento' in data.columns else None,
                    'nombre_distrito': data.iloc[idx].get('nombre_distrito', 'N/A'),
                    'nombre_establecimiento': data.iloc[idx].get('nombre_establecimiento', 'N/A'),
                    'fecha_prediccion': future_date.strftime('%Y-%m-%d'),
                    'mes_adelante': month_ahead,
                    'casos_predichos': float(pred_values[idx]),
                    'casos_minimos': float(lower_bounds[idx]),
                    'casos_maximos': float(upper_bounds[idx]),
                    'intervalo_confianza': f"{lower_bounds[idx]:.1f} - {upper_bounds[idx]:.1f}",
                    'nivel_confianza': 95
                }
                
                predictions.append(pred_dict)
        
        return predictions
    
    def _prepare_future_data(self, data: pd.DataFrame, future_date: pd.Timestamp, 
                           month_ahead: int) -> pd.DataFrame:
        """
        Preparar datos para predicción futura
        
        Args:
            data: Datos base
            future_date: Fecha futura
            month_ahead: Meses hacia adelante
            
        Returns:
            DataFrame preparado para predicción
        """
        # Tomar los datos más recientes como base
        recent_data = data.groupby(['id_distrito', 'id_establecimiento']).tail(1).copy()
        
        # Actualizar features temporales
        recent_data['year'] = future_date.year
        recent_data['month'] = future_date.month
        recent_data['quarter'] = future_date.quarter
        recent_data['month_sin'] = np.sin(2 * np.pi * future_date.month / 12)
        recent_data['month_cos'] = np.cos(2 * np.pi * future_date.month / 12)
        
        # Seleccionar solo las columnas que el modelo espera
        feature_cols = [col for col in self.X.columns if col in recent_data.columns]
        return recent_data[feature_cols]
    
    def _generate_alerts(self, predictions: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """
        Generar alertas basadas en predicciones
        
        Args:
            predictions: Lista de predicciones
            
        Returns:
            Lista con alertas
        """
        alerts = []
        
        for pred in predictions:
            casos_predichos = pred['casos_predichos']
            alert_level = 'normal'
            alert_message = ''
            
            # Determinar nivel de alerta
            if casos_predichos >= self.alert_thresholds['critical']:
                alert_level = 'critical'
                alert_message = f'Alerta CRÍTICA: Se predicen {casos_predichos:.0f} casos'
            elif casos_predichos >= self.alert_thresholds['high']:
                alert_level = 'high'
                alert_message = f'Alerta ALTA: Se predicen {casos_predichos:.0f} casos'
            elif casos_predichos >= self.alert_thresholds['medium']:
                alert_level = 'medium'
                alert_message = f'Alerta MEDIA: Se predicen {casos_predichos:.0f} casos'
            elif casos_predichos >= self.alert_thresholds['low']:
                alert_level = 'low'
                alert_message = f'Alerta BAJA: Se predicen {casos_predichos:.0f} casos'
            else:
                alert_message = f'Situación normal: {casos_predichos:.0f} casos predichos'
            
            alert = {
                'id_distrito': pred['id_distrito'],
                'id_establecimiento': pred['id_establecimiento'],
                'nombre_distrito': pred['nombre_distrito'],
                'nombre_establecimiento': pred['nombre_establecimiento'],
                'fecha_prediccion': pred['fecha_prediccion'],
                'casos_predichos': casos_predichos,
                'alert_level': alert_level,
                'alert_message': alert_message,
                'requires_attention': alert_level in ['high', 'critical'],
                'priority': {'critical': 1, 'high': 2, 'medium': 3, 'low': 4, 'normal': 5}[alert_level]
            }
            
            alerts.append(alert)
        
        # Ordenar por prioridad
        alerts.sort(key=lambda x: x['priority'])
        
        return alerts
    
    def _create_risk_ranking(self, predictions: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """
        Crear ranking de riesgo por establecimiento
        
        Args:
            predictions: Lista de predicciones
            
        Returns:
            Lista con ranking de riesgo
        """
        # Agrupar por establecimiento y calcular métricas
        establishment_metrics = {}
        
        for pred in predictions:
            est_id = pred['id_establecimiento']
            
            if est_id not in establishment_metrics:
                establishment_metrics[est_id] = {
                    'id_distrito': pred['id_distrito'],
                    'id_establecimiento': est_id,
                    'nombre_distrito': pred['nombre_distrito'],
                    'nombre_establecimiento': pred['nombre_establecimiento'],
                    'casos_total_predichos': 0,
                    'casos_promedio': 0,
                    'casos_maximo': 0,
                    'meses_con_alertas': 0,
                    'alertas_criticas': 0,
                    'alertas_altas': 0,
                    'predictions_count': 0
                }
            
            metrics = establishment_metrics[est_id]
            metrics['casos_total_predichos'] += pred['casos_predichos']
            metrics['casos_maximo'] = max(metrics['casos_maximo'], pred['casos_predichos'])
            metrics['predictions_count'] += 1
            
            # Contar alertas
            if pred['casos_predichos'] >= self.alert_thresholds['critical']:
                metrics['alertas_criticas'] += 1
                metrics['meses_con_alertas'] += 1
            elif pred['casos_predichos'] >= self.alert_thresholds['high']:
                metrics['alertas_altas'] += 1
                metrics['meses_con_alertas'] += 1
        
        # Calcular métricas finales y crear ranking
        risk_ranking = []
        
        for est_id, metrics in establishment_metrics.items():
            metrics['casos_promedio'] = metrics['casos_total_predichos'] / metrics['predictions_count']
            
            # Calcular puntaje de riesgo
            risk_score = (
                metrics['casos_promedio'] * 0.4 +
                metrics['casos_maximo'] * 0.3 +
                metrics['alertas_criticas'] * 10 +
                metrics['alertas_altas'] * 5 +
                metrics['meses_con_alertas'] * 2
            )
            
            metrics['risk_score'] = risk_score
            metrics['risk_level'] = self._categorize_risk(risk_score)
            
            risk_ranking.append(metrics)
        
        # Ordenar por puntaje de riesgo (mayor a menor)
        risk_ranking.sort(key=lambda x: x['risk_score'], reverse=True)
        
        # Añadir posición en ranking
        for i, item in enumerate(risk_ranking):
            item['ranking_position'] = i + 1
        
        return risk_ranking
    
    def _categorize_risk(self, risk_score: float) -> str:
        """
        Categorizar nivel de riesgo
        
        Args:
            risk_score: Puntaje de riesgo
            
        Returns:
            Categoría de riesgo
        """
        if risk_score >= 50:
            return 'muy_alto'
        elif risk_score >= 30:
            return 'alto'
        elif risk_score >= 15:
            return 'medio'
        elif risk_score >= 5:
            return 'bajo'
        else:
            return 'muy_bajo'
    
    def save_model(self, model_path: str, model_name: str = None) -> Dict[str, Any]:
        """
        Guardar modelo entrenado
        
        Args:
            model_path: Ruta donde guardar el modelo
            model_name: Nombre del modelo (opcional)
            
        Returns:
            Dict con status y información del guardado
        """
        try:
            if self.model is None:
                return {
                    'status': False,
                    'message': 'No hay modelo entrenado para guardar',
                    'error_code': 'NO_MODEL_TO_SAVE'
                }
            
            # Crear directorio si no existe
            os.makedirs(model_path, exist_ok=True)
            
            # Generar nombre si no se proporciona
            if not model_name:
                timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
                model_name = f'vih_xgboost_model_{timestamp}'
            
            # Rutas de archivos
            model_file = os.path.join(model_path, f'{model_name}.pkl')
            config_file = os.path.join(model_path, f'{model_name}_config.json')
            
            # Preparar datos para guardar
            model_data = {
                'model': self.model,
                'scaler': self.scaler,
                'label_encoders': self.label_encoders,
                'feature_importance': self.feature_importance,
                'training_history': self.training_history,
                'prediction_intervals': self.prediction_intervals,
                'alert_thresholds': self.alert_thresholds,
                'config': self.config,
                'feature_columns': list(self.X.columns) if self.X is not None else []
            }
            
            # Guardar modelo
            joblib.dump(model_data, model_file)
            
            # Guardar configuración separada
            config_data = {
                'model_name': model_name,
                'creation_date': datetime.now().isoformat(),
                'config': self.config,
                'training_history': self.training_history,
                'alert_thresholds': self.alert_thresholds
            }
            
            with open(config_file, 'w', encoding='utf-8') as f:
                json.dump(config_data, f, indent=2, ensure_ascii=False)
            
            return {
                'status': True,
                'message': 'Modelo guardado exitosamente',
                'model_file': model_file,
                'config_file': config_file,
                'model_name': model_name
            }
            
        except Exception as e:
            return {
                'status': False,
                'message': f'Error al guardar modelo: {str(e)}',
                'error_code': 'SAVE_ERROR',
                'traceback': traceback.format_exc()
            }
    
    def load_model(self, model_file: str) -> Dict[str, Any]:
        """
        Cargar modelo pre-entrenado
        
        Args:
            model_file: Ruta del archivo del modelo
            
        Returns:
            Dict con status y información
        """
        try:
            if not os.path.exists(model_file):
                return {
                    'status': False,
                    'message': f'Archivo de modelo no encontrado: {model_file}',
                    'error_code': 'MODEL_FILE_NOT_FOUND'
                }
            
            # Cargar modelo
            model_data = joblib.load(model_file)
            
            # Restaurar atributos
            self.model = model_data['model']
            self.scaler = model_data['scaler']
            self.label_encoders = model_data['label_encoders']
            self.feature_importance = model_data['feature_importance']
            self.training_history = model_data['training_history']
            self.prediction_intervals = model_data['prediction_intervals']
            self.alert_thresholds = model_data['alert_thresholds']
            self.config = model_data['config']
            
            return {
                'status': True,
                'message': 'Modelo cargado exitosamente',
                'model_info': {
                    'creation_date': self.training_history.get('timestamp', 'N/A'),
                    'feature_count': len(model_data.get('feature_columns', [])),
                    'config': self.config
                }
            }
            
        except Exception as e:
            return {
                'status': False,
                'message': f'Error al cargar modelo: {str(e)}',
                'error_code': 'LOAD_ERROR',
                'traceback': traceback.format_exc()
            }
    
    def generate_visualization_data(self) -> Dict[str, Any]:
        """
        Generar datos para visualizaciones en JavaScript
        
        Returns:
            Dict con datos para visualizaciones
        """
        try:
            if self.model is None:
                return {
                    'status': False,
                    'message': 'Modelo no entrenado',
                    'error_code': 'NO_MODEL_FOR_VISUALIZATION'
                }
            
            viz_data = {
                'feature_importance': self.feature_importance[:15],  # Top 15 características
                'training_metrics': self.training_history.get('metrics', {}),
                'alert_thresholds': self.alert_thresholds,
                'data_summary': self._get_data_summary(),
                'model_performance': self._get_model_performance_data()
            }
            
            return {
                'status': True,
                'message': 'Datos de visualización generados',
                'visualization_data': viz_data
            }
            
        except Exception as e:
            return {
                'status': False,
                'message': f'Error generando datos de visualización: {str(e)}',
                'error_code': 'VISUALIZATION_ERROR',
                'traceback': traceback.format_exc()
            }
    
    def _get_data_summary(self) -> Dict[str, Any]:
        """
        Obtener resumen de datos
        
        Returns:
            Dict con resumen
        """
        if not hasattr(self, 'processed_data') or self.processed_data is None:
            return {}
        
        return {
            'total_records': len(self.processed_data),
            'districts_count': self.processed_data['id_distrito'].nunique() if 'id_distrito' in self.processed_data.columns else 0,
            'establishments_count': self.processed_data['id_establecimiento'].nunique() if 'id_establecimiento' in self.processed_data.columns else 0,
            'date_range': self._get_date_range(),
            'target_distribution': self._get_target_distribution()
        }
    
    def _get_target_distribution(self) -> Dict[str, Any]:
        """
        Obtener distribución de variable objetivo
        
        Returns:
            Dict con distribución
        """
        if self.y is None:
            return {}
        
        return {
            'mean': float(self.y.mean()),
            'median': float(self.y.median()),
            'std': float(self.y.std()),
            'min': float(self.y.min()),
            'max': float(self.y.max()),
            'percentiles': {
                '25': float(self.y.quantile(0.25)),
                '50': float(self.y.quantile(0.50)),
                '75': float(self.y.quantile(0.75)),
                '90': float(self.y.quantile(0.90)),
                '95': float(self.y.quantile(0.95))
            }
        }
    
    def _get_model_performance_data(self) -> Dict[str, Any]:
        """
        Obtener datos de performance del modelo
        
        Returns:
            Dict con datos de performance
        """
        if not hasattr(self, 'training_history') or not self.training_history:
            return {}
        
        return {
            'metrics': self.training_history.get('metrics', {}),
            'training_samples': self.training_history.get('training_samples', 0),
            'test_samples': self.training_history.get('test_samples', 0),
            'feature_count': self.training_history.get('feature_count', 0),
            'training_date': self.training_history.get('timestamp', 'N/A')
        }


def main():
    """
    Función principal para ejecutar desde línea de comandos
    """
    parser = argparse.ArgumentParser(description='Entrenador XGBoost para Predicción de Casos VIH')
    parser.add_argument('--data_file', required=True, help='Ruta del archivo CSV con datos')
    parser.add_argument('--model_path', required=True, help='Ruta donde guardar el modelo')
    parser.add_argument('--model_name', help='Nombre del modelo (opcional)')
    parser.add_argument('--target_column', default='total_cuestionarios', help='Columna objetivo')
    parser.add_argument('--horizon_months', type=int, default=3, help='Meses de predicción')
    parser.add_argument('--config_file', help='Archivo de configuración JSON (opcional)')
    parser.add_argument('--output_file', help='Archivo de salida JSON (opcional)')
    parser.add_argument('--predict_only', action='store_true', help='Solo hacer predicciones (requiere modelo existente)')
    parser.add_argument('--load_model', help='Cargar modelo existente')
    
    args = parser.parse_args()
    
    # Resultado principal
    result = {
        'status': False,
        'message': '',
        'timestamp': datetime.now().isoformat(),
        'args': vars(args)
    }
    
    try:
        # Cargar configuración personalizada si existe
        config = {}
        if args.config_file and os.path.exists(args.config_file):
            with open(args.config_file, 'r', encoding='utf-8') as f:
                config = json.load(f)
        
        # Actualizar configuración con argumentos
        config.update({
            'target_column': args.target_column,
            'horizon_months': args.horizon_months
        })
        
        # Crear predictor
        predictor = VIHCasePredictor(config)
        
        # Modo solo predicción
        if args.predict_only:
            if not args.load_model:
                result['message'] = 'Modo predict_only requiere --load_model'
                result['error_code'] = 'MISSING_MODEL_FOR_PREDICTION'
            else:
                # Cargar modelo
                load_result = predictor.load_model(args.load_model)
                if not load_result['status']:
                    result = load_result
                else:
                    # Cargar datos
                    data_result = predictor.load_data(args.data_file)
                    if not data_result['status']:
                        result = data_result
                    else:
                        # Preprocesar datos
                        prep_result = predictor.preprocess_data()
                        if not prep_result['status']:
                            result = prep_result
                        else:
                            # Hacer predicciones
                            pred_result = predictor.predict_future(args.horizon_months)
                            result = pred_result
        
        # Modo entrenamiento completo
        else:
            # Cargar modelo existente si se especifica
            if args.load_model:
                load_result = predictor.load_model(args.load_model)
                if not load_result['status']:
                    result = load_result
                    print(json.dumps(result, indent=2, ensure_ascii=False))
                    return
            
            # Cargar datos
            data_result = predictor.load_data(args.data_file)
            if not data_result['status']:
                result = data_result
            else:
                result['data_info'] = data_result['data_info']
                
                # Preprocesar datos
                prep_result = predictor.preprocess_data()
                if not prep_result['status']:
                    result = prep_result
                else:
                    result['preprocessing_info'] = prep_result['preprocessing_info']
                    
                    # Entrenar modelo
                    train_result = predictor.train_model()
                    if not train_result['status']:
                        result = train_result
                    else:
                        result['training_info'] = train_result['training_info']
                        result['metrics'] = train_result['metrics']
                        result['feature_importance'] = train_result['feature_importance']
                        
                        # Guardar modelo
                        save_result = predictor.save_model(args.model_path, args.model_name)
                        if not save_result['status']:
                            result = save_result
                        else:
                            result['model_info'] = save_result
                            
                            # Generar predicciones
                            pred_result = predictor.predict_future(args.horizon_months)
                            if pred_result['status']:
                                result['predictions'] = pred_result['predictions']
                                result['alerts'] = pred_result['alerts']
                                result['risk_ranking'] = pred_result['risk_ranking']
                                
                                # Generar datos de visualización
                                viz_result = predictor.generate_visualization_data()
                                if viz_result['status']:
                                    result['visualization_data'] = viz_result['visualization_data']
                                
                                result['status'] = True
                                result['message'] = 'Entrenamiento y predicción completados exitosamente'
                            else:
                                result = pred_result
    
    except Exception as e:
        result['message'] = f'Error inesperado: {str(e)}'
        result['error_code'] = 'UNEXPECTED_ERROR'
        result['traceback'] = traceback.format_exc()
    
    # Guardar resultado en archivo si se especifica
    if args.output_file:
        try:
            with open(args.output_file, 'w', encoding='utf-8') as f:
                json.dump(result, f, indent=2, ensure_ascii=False)
        except Exception as e:
            result['output_file_error'] = f'Error guardando archivo de salida: {str(e)}'
    
    # Imprimir resultado JSON
    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == '__main__':
    main()