'use client';

import { useState, useEffect } from 'react';
import * as Slider from '@radix-ui/react-slider';
import * as Label from '@radix-ui/react-label';
import { useSession } from 'next-auth/react';
import { useProfiles, Profile } from '@/hooks/useProfiles';
import ProfileSelector from '../ProfileSelector/ProfileSelector';

interface MacroData {
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
}

export default function MacroBuilder() {
  const { data: session } = useSession();
  const { profiles, loading: profilesLoading, updateProfile } = useProfiles();
  const [selectedProfile, setSelectedProfile] = useState<Profile | null>(null);
  const [macros, setMacros] = useState<MacroData>({
    calories: 2000,
    protein: 150,
    carbs: 200,
    fat: 67,
  });

  const [scalePercentage, setScalePercentage] = useState(100);
  const [saveTimeout, setSaveTimeout] = useState<NodeJS.Timeout | null>(null);

  // Load initial profile
  useEffect(() => {
    if (profiles.length > 0 && !selectedProfile) {
      const defaultProfile = profiles[0];
      setSelectedProfile(defaultProfile);
      setMacros({
        calories: defaultProfile.calories,
        protein: defaultProfile.protein,
        carbs: defaultProfile.carbs,
        fat: defaultProfile.fat,
      });
    }
  }, [profiles, selectedProfile]);

  // Auto-save changes to profile
  const saveChanges = async (newMacros: MacroData) => {
    if (selectedProfile) {
      try {
        await updateProfile(selectedProfile.id, newMacros);
      } catch (error) {
        console.error('Failed to save profile:', error);
      }
    }
  };

  // Debounced save
  useEffect(() => {
    if (saveTimeout) {
      clearTimeout(saveTimeout);
    }

    if (selectedProfile) {
      const timeout = setTimeout(() => {
        saveChanges(macros);
      }, 1000);
      setSaveTimeout(timeout);
    }

    return () => {
      if (saveTimeout) {
        clearTimeout(saveTimeout);
      }
    };
  }, [macros]);

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
  const handleScaleChange = (newScale: number[]) => {
    const scaleFactor = newScale[0] / 100;
    setScalePercentage(newScale[0]);
    setMacros(prev => ({
      calories: Math.round(prev.calories * scaleFactor),
      protein: Math.round(prev.protein * scaleFactor),
      carbs: Math.round(prev.carbs * scaleFactor),
      fat: Math.round(prev.fat * scaleFactor),
    }));
  };

  // Handle individual macro changes
  const handleMacroChange = (macro: keyof MacroData, value: number | number[]) => {
    const newValue = Math.max(0, Array.isArray(value) ? value[0] : value);
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

  // Handle profile selection
  const handleProfileSelect = (profile: Profile) => {
    setSelectedProfile(profile);
    setMacros({
      calories: profile.calories,
      protein: profile.protein,
      carbs: profile.carbs,
      fat: profile.fat,
    });
  };

  const percentages = calculatePercentages(macros.protein, macros.carbs, macros.fat);

  const macroColors = {
    protein: '#FF6B42',
    carbs: '#636366',
    fat: '#8E8E93',
  };

  if (!session) {
    return (
      <div className="text-center py-8">
        <p className="text-gray-600">Please sign in to use the Macro Builder</p>
      </div>
    );
  }

  return (
    <div className="space-y-8">
      {/* Profile Selector */}
      <ProfileSelector
        onProfileSelect={handleProfileSelect}
        selectedProfileId={selectedProfile?.id}
      />

      {/* Macro Builder */}
      <div className="max-w-2xl mx-auto bg-white rounded-lg shadow-sm p-6">
        <div className="mb-8">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            Daily Targets
          </h2>
          <div className="flex flex-col sm:flex-row gap-4 items-center">
            <div className="flex-grow w-full sm:w-2/3">
              <Slider.Root
                className="RadixSlider-root"
                value={[scalePercentage]}
                onValueChange={handleScaleChange}
                min={50}
                max={150}
                step={1}
              >
                <Slider.Track className="RadixSlider-track">
                  <Slider.Range className="RadixSlider-range" />
                </Slider.Track>
                <Slider.Thumb className="RadixSlider-thumb" aria-label="Scale percentage" />
              </Slider.Root>
              <div className="flex justify-between mt-1 text-sm text-gray-600">
                <span>50%</span>
                <span>100%</span>
                <span>150%</span>
              </div>
            </div>
            <div className="w-full sm:w-1/3">
              <Label.Root className="block text-sm font-medium text-gray-700 mb-1" htmlFor="calories">
                Calories
              </Label.Root>
              <input
                id="calories"
                type="number"
                value={macros.calories}
                onChange={(e) => handleMacroChange('calories', Number(e.target.value))}
                className="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
              />
            </div>
          </div>
        </div>

        <hr className="my-6 border-gray-200" />

        <div className="space-y-6">
          {[
            { name: 'Protein', key: 'protein' },
            { name: 'Carbs', key: 'carbs' },
            { name: 'Fat', key: 'fat' },
          ].map(({ name, key }) => (
            <div key={key}>
              <div className="flex justify-between items-center mb-2">
                <Label.Root className="text-sm font-semibold text-gray-900" htmlFor={key}>
                  {name}
                </Label.Root>
                <span className="inline-flex items-center px-2.5 py-0.5 rounded-md text-sm font-medium bg-gray-100 text-gray-800">
                  {macros[key as keyof MacroData]}g ({Math.round(percentages[key as keyof typeof percentages])}%)
                </span>
              </div>
              <div className="flex items-center gap-4">
                <div className="flex-grow">
                  <Slider.Root
                    className="RadixSlider-root"
                    value={[macros[key as keyof MacroData]]}
                    onValueChange={(value) => handleMacroChange(key as keyof MacroData, value)}
                    min={0}
                    max={key === 'fat' ? 200 : 400}
                    step={1}
                  >
                    <Slider.Track className="RadixSlider-track">
                      <Slider.Range 
                        className="RadixSlider-range" 
                        style={{ backgroundColor: macroColors[key as keyof typeof macroColors] }} 
                      />
                    </Slider.Track>
                    <Slider.Thumb 
                      className="RadixSlider-thumb"
                      style={{ borderColor: macroColors[key as keyof typeof macroColors] }}
                      aria-label={`${name} value`}
                    />
                  </Slider.Root>
                </div>
                <input
                  id={key}
                  type="number"
                  value={macros[key as keyof MacroData]}
                  onChange={(e) => handleMacroChange(key as keyof MacroData, Number(e.target.value))}
                  className="w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm bg-gray-50"
                />
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
