'use client';

import { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  Slider,
  TextField,
  Grid,
  Divider,
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
    <Card elevation={2} sx={{ maxWidth: 600, mx: 'auto' }}>
      <CardContent>
        <Box sx={{ mb: 3 }}>
          <Typography variant="h6" gutterBottom color="primary">
            Daily Targets
          </Typography>
          <Grid container spacing={2} alignItems="center">
            <Grid item xs={12} sm={8}>
              <Slider
                value={scalePercentage}
                onChange={(_, value) => handleScaleChange(value as number)}
                min={50}
                max={150}
                marks={[
                  { value: 50, label: '50%' },
                  { value: 100, label: '100%' },
                  { value: 150, label: '150%' },
                ]}
              />
            </Grid>
            <Grid item xs={12} sm={4}>
              <TextField
                fullWidth
                label="Calories"
                value={macros.calories}
                onChange={(e) => handleMacroChange('calories', Number(e.target.value))}
                variant="outlined"
                size="small"
                type="number"
              />
            </Grid>
          </Grid>
        </Box>

        <Divider sx={{ my: 2 }} />

        <Grid container spacing={3}>
          {[
            { name: 'Protein', key: 'protein', color: '#FF6B6B' },
            { name: 'Carbs', key: 'carbs', color: '#4ECDC4' },
            { name: 'Fat', key: 'fat', color: '#45B7D1' },
          ].map(({ name, key, color }) => (
            <Grid item xs={12} key={key}>
              <Box sx={{ mb: 1 }}>
                <Grid container justifyContent="space-between" alignItems="center">
                  <Grid item>
                    <Typography variant="subtitle2">
                      {name} ({Math.round(percentages[key as keyof typeof percentages])}%)
                    </Typography>
                  </Grid>
                  <Grid item>
                    <Typography variant="body2" color="text.secondary">
                      {macros[key as keyof MacroData]}g
                    </Typography>
                  </Grid>
                </Grid>
              </Box>
              <Grid container spacing={2} alignItems="center">
                <Grid item xs>
                  <Slider
                    value={macros[key as keyof MacroData]}
                    onChange={(_, value) => handleMacroChange(key as keyof MacroData, value as number)}
                    min={0}
                    max={key === 'fat' ? 200 : 400}
                    sx={{
                      '& .MuiSlider-thumb': {
                        backgroundColor: color,
                      },
                      '& .MuiSlider-track': {
                        backgroundColor: color,
                      },
                    }}
                  />
                </Grid>
                <Grid item>
                  <TextField
                    size="small"
                    value={macros[key as keyof MacroData]}
                    onChange={(e) => handleMacroChange(key as keyof MacroData, Number(e.target.value))}
                    type="number"
                    sx={{ width: 80 }}
                  />
                </Grid>
              </Grid>
            </Grid>
          ))}
        </Grid>
      </CardContent>
    </Card>
  );
}
