import { useState, useEffect } from 'react';
import { useSession } from 'next-auth/react';

export interface Profile {
  id: string;
  name: string;
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
  userId: string;
  createdAt: string;
  updatedAt: string;
}

export function useProfiles() {
  const { data: session } = useSession();
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Fetch all profiles
  const fetchProfiles = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/profiles');
      if (!response.ok) throw new Error('Failed to fetch profiles');
      const data = await response.json();
      setProfiles(data);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch profiles');
    } finally {
      setLoading(false);
    }
  };

  // Create a new profile
  const createProfile = async (profileData: Omit<Profile, 'id' | 'userId' | 'createdAt' | 'updatedAt'>) => {
    try {
      const response = await fetch('/api/profiles', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(profileData),
      });
      if (!response.ok) throw new Error('Failed to create profile');
      const newProfile = await response.json();
      setProfiles(prev => [...prev, newProfile]);
      return newProfile;
    } catch (err) {
      throw new Error(err instanceof Error ? err.message : 'Failed to create profile');
    }
  };

  // Update a profile
  const updateProfile = async (id: string, profileData: Partial<Profile>) => {
    try {
      const response = await fetch(`/api/profiles/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(profileData),
      });
      if (!response.ok) throw new Error('Failed to update profile');
      const updatedProfile = await response.json();
      setProfiles(prev => 
        prev.map(profile => 
          profile.id === id ? updatedProfile : profile
        )
      );
      return updatedProfile;
    } catch (err) {
      throw new Error(err instanceof Error ? err.message : 'Failed to update profile');
    }
  };

  // Delete a profile
  const deleteProfile = async (id: string) => {
    try {
      const response = await fetch(`/api/profiles/${id}`, {
        method: 'DELETE',
      });
      if (!response.ok) throw new Error('Failed to delete profile');
      setProfiles(prev => prev.filter(profile => profile.id !== id));
    } catch (err) {
      throw new Error(err instanceof Error ? err.message : 'Failed to delete profile');
    }
  };

  // Fetch profiles when session changes
  useEffect(() => {
    if (session) {
      fetchProfiles();
    }
  }, [session]);

  return {
    profiles,
    loading,
    error,
    createProfile,
    updateProfile,
    deleteProfile,
    refreshProfiles: fetchProfiles,
  };
}
