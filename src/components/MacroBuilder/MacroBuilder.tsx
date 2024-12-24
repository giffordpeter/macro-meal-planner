'use client';

import { useState, useEffect } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  Slider,
  TextField,
  Grid,
  LinearProgress,
} from '@mui/material';

interface MacroData {
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
}

export default function MacroBuilder() {
  const [macros, setMacros] = useState<MacroData>({
    calories: 2000,
    protein: 150,
    carbs: 200,
    fat: 67,
  });

  const [scalePercentage, setScalePercentage] = useState(100);

  // Calculate calories from individual macros
  const calculateCalories = (protein: number, carbs: number, fat: number) => {
    return protein * 4 + carbs * 4 + fat * 9;
  };

  // Calculate macro percentages
  const calculatePercentages = (protein: number, carbs: number, fat: number) => {
    const totalCals = calculateCalories(protein, carbs, fat);
    return {
      protein: (protein * 4 * 100) / totalCals,
      carbs: (carbs * 4 * 100) / totalCals,
      fat: (fat * 9 * 100) / totalCals,
    };
  };

  // Handle scaling all macros proportionally
  const handleScaleChange = (newScale: number) => {
    const scaleFactor = newScale / 100;
    setScalePercentage(newScale);
    setMacros(prev => ({
      calories: Math.round(prev.calories * scaleFactor),
      protein: Math.round(prev.protein * scaleFactor),
      carbs: Math.round(prev.carbs * scaleFactor),
      fat: Math.round(prev.fat * scaleFactor),
    }));
  };

  // Handle individual macro changes
  const handleMacroChange = (macro: keyof MacroData, value: number) => {
    const newValue = Math.max(0, value);
    setMacros(prev => {
      const newMacros = { ...prev, [macro]: newValue };
      if (macro !== 'calories') {
        newMacros.calories = calculateCalories(
          newMacros.protein,
          newMacros.carbs,
          newMacros.fat
        );
      }
      return newMacros;
    });
  };

  const percentages = calculatePercentages(macros.protein, macros.carbs, macros.fat);

  return (
    <Card>
      <CardContent>
        <Typography variant="h5" gutterBottom>
          Macro Builder
        </Typography>
        
        <Box sx={{ mb: 4 }}>
          <Typography gutterBottom>Scale Calories</Typography>
          <Slider
            value={scalePercentage}
            onChange={(_, value) => handleScaleChange(value as number)}
            min={50}
            max={150}
            step={1}
            marks={[
              { value: 50, label: '50%' },
              { value: 100, label: '100%' },
              { value: 150, label: '150%' },
            ]}
            sx={{ width: '100%' }}
          />
        </Box>

        <Grid container spacing={3}>
          <Grid item xs={12}>
            <TextField
              fullWidth
              label="Total Calories"
              type="number"
              value={macros.calories}
              onChange={(e) => handleMacroChange('calories', Number(e.target.value))}
              variant="outlined"
            />
          </Grid>

          {/* Macro inputs with progress bars */}
          {[
            { name: 'Protein', key: 'protein', color: '#FF6B6B' },
            { name: 'Carbs', key: 'carbs', color: '#4ECDC4' },
            { name: 'Fat', key: 'fat', color: '#45B7D1' },
          ].map(({ name, key, color }) => (
            <Grid item xs={12} key={key}>
              <Typography variant="subtitle2" gutterBottom>
                {name} ({Math.round(percentages[key as keyof typeof percentages])}%)
              </Typography>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                <TextField
                  fullWidth
                  label={`${name} (g)`}
                  type="number"
                  value={macros[key as keyof MacroData]}
                  onChange={(e) => handleMacroChange(key as keyof MacroData, Number(e.target.value))}
                  variant="outlined"
                />
              </Box>
              <LinearProgress
                variant="determinate"
                value={percentages[key as keyof typeof percentages]}
                sx={{
                  height: 8,
                  borderRadius: 4,
                  mt: 1,
                  backgroundColor: '#eee',
                  '& .MuiLinearProgress-bar': {
                    backgroundColor: color,
                  },
                }}
              />
            </Grid>
          ))}
        </Grid>
      </CardContent>
    </Card>
  );
}
