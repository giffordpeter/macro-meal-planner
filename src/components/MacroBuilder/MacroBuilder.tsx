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

  const macroColors = {
    protein: '#FF6B42', // MacroFactor's orange
    carbs: '#636366', // Dark gray
    fat: '#8E8E93', // Medium gray
  };

  return (
    <Card elevation={0} sx={{ maxWidth: 600, mx: 'auto', bgcolor: 'background.paper' }}>
      <CardContent sx={{ p: 3 }}>
        <Box sx={{ mb: 4 }}>
          <Typography variant="h6" gutterBottom sx={{ color: 'text.primary', fontWeight: 600 }}>
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
                sx={{
                  '& .MuiSlider-thumb': {
                    backgroundColor: 'primary.main',
                  },
                  '& .MuiSlider-track': {
                    backgroundColor: 'primary.main',
                  },
                }}
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

        <Divider sx={{ my: 3 }} />

        <Grid container spacing={3}>
          {[
            { name: 'Protein', key: 'protein' },
            { name: 'Carbs', key: 'carbs' },
            { name: 'Fat', key: 'fat' },
          ].map(({ name, key }) => (
            <Grid item xs={12} key={key}>
              <Box sx={{ mb: 1 }}>
                <Grid container justifyContent="space-between" alignItems="center">
                  <Grid item>
                    <Typography variant="subtitle2" sx={{ color: 'text.primary', fontWeight: 600 }}>
                      {name}
                    </Typography>
                  </Grid>
                  <Grid item>
                    <Typography 
                      variant="body2" 
                      sx={{ 
                        color: 'text.secondary',
                        backgroundColor: 'rgba(0, 0, 0, 0.04)',
                        px: 1,
                        py: 0.5,
                        borderRadius: 1,
                        fontWeight: 500
                      }}
                    >
                      {macros[key as keyof MacroData]}g ({Math.round(percentages[key as keyof typeof percentages])}%)
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
                        backgroundColor: macroColors[key as keyof typeof macroColors],
                      },
                      '& .MuiSlider-track': {
                        backgroundColor: macroColors[key as keyof typeof macroColors],
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
                    sx={{ 
                      width: 80,
                      '& .MuiOutlinedInput-root': {
                        backgroundColor: 'rgba(0, 0, 0, 0.04)',
                      }
                    }}
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
