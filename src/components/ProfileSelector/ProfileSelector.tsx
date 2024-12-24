'use client';

import { useState } from 'react';
import { useProfiles, Profile } from '@/hooks/useProfiles';

interface ProfileSelectorProps {
  onProfileSelect: (profile: Profile) => void;
  selectedProfileId?: string;
}

export default function ProfileSelector({
  onProfileSelect,
  selectedProfileId,
}: ProfileSelectorProps) {
  const { profiles, loading, error, createProfile, deleteProfile } = useProfiles();
  const [isCreating, setIsCreating] = useState(false);
  const [newProfileName, setNewProfileName] = useState('');

  const handleCreateProfile = async () => {
    if (!newProfileName.trim()) return;

    try {
      const newProfile = await createProfile({
        name: newProfileName,
        calories: 2000,
        protein: 150,
        carbs: 200,
        fat: 67,
      });
      setNewProfileName('');
      setIsCreating(false);
      onProfileSelect(newProfile);
    } catch (error) {
      console.error('Failed to create profile:', error);
    }
  };

  if (loading) {
    return <div className="text-gray-600">Loading profiles...</div>;
  }

  if (error) {
    return <div className="text-red-600">Error loading profiles: {error}</div>;
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-semibold text-gray-900">Your Profiles</h3>
        <button
          onClick={() => setIsCreating(true)}
          className="text-sm text-blue-600 hover:text-blue-500"
        >
          + New Profile
        </button>
      </div>

      {isCreating && (
        <div className="flex items-center gap-2">
          <input
            type="text"
            value={newProfileName}
            onChange={(e) => setNewProfileName(e.target.value)}
            placeholder="Profile name"
            className="flex-1 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
          />
          <button
            onClick={handleCreateProfile}
            className="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
          >
            Create
          </button>
          <button
            onClick={() => setIsCreating(false)}
            className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
          >
            Cancel
          </button>
        </div>
      )}

      <div className="space-y-2">
        {profiles.map((profile) => (
          <div
            key={profile.id}
            className={`flex items-center justify-between p-3 rounded-md cursor-pointer ${
              selectedProfileId === profile.id
                ? 'bg-blue-50 border-blue-200'
                : 'bg-white border-gray-200'
            } border`}
            onClick={() => onProfileSelect(profile)}
          >
            <div>
              <h4 className="font-medium text-gray-900">{profile.name}</h4>
              <p className="text-sm text-gray-500">
                {profile.calories} cal · {profile.protein}p · {profile.carbs}c · {profile.fat}f
              </p>
            </div>
            {profiles.length > 1 && (
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  if (confirm('Are you sure you want to delete this profile?')) {
                    deleteProfile(profile.id);
                  }
                }}
                className="text-gray-400 hover:text-red-600"
              >
                Delete
              </button>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
