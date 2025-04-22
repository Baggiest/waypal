export interface Business {
  id: string;
  name: string;
  description: string;
  address: string;
  latitude: number;
  longitude: number;
  website?: string;
  phone?: string;
  rating?: number;
  distance: number; // Distance from the search coordinates in kilometers
} 