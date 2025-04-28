-- Enable PostGIS extension if not already enabled
CREATE EXTENSION IF NOT EXISTS postgis;

-- Insert mock businesses with locations in San Francisco area
INSERT INTO businesses (id, name, description, address, location, website, phone, rating)
VALUES
  (
    gen_random_uuid(),
    'Golden Gate Cafe',
    'Cozy cafe with bay views',
    '1 Golden Gate Bridge, San Francisco, CA',
    ST_SetSRID(ST_MakePoint(-122.4784, 37.8199), 4326),
    'https://goldengatecafe.com',
    '415-555-0101',
    4.5
  ),
  (
    gen_random_uuid(),
    'Fishermans Wharf Seafood',
    'Fresh seafood restaurant',
    '2 Fishermans Wharf, San Francisco, CA',
    ST_SetSRID(ST_MakePoint(-122.4098, 37.8087), 4326),
    'https://fishermanswharf.com',
    '415-555-0102',
    4.2
  ),
  (
    gen_random_uuid(),
    'Alcatraz Tours',
    'Historical prison tours',
    '3 Alcatraz Island, San Francisco, CA',
    ST_SetSRID(ST_MakePoint(-122.4226, 37.8267), 4326),
    'https://alcatraztours.com',
    '415-555-0103',
    4.8
  ),
  (
    gen_random_uuid(),
    'Golden Gate Park Gardens',
    'Beautiful botanical gardens',
    '4 Golden Gate Park, San Francisco, CA',
    ST_SetSRID(ST_MakePoint(-122.4664, 37.7694), 4326),
    'https://goldengatepark.com',
    '415-555-0104',
    4.6
  ),
  (
    gen_random_uuid(),
    'Pier 39 Shops',
    'Shopping and entertainment complex',
    '5 Pier 39, San Francisco, CA',
    ST_SetSRID(ST_MakePoint(-122.4088, 37.8087), 4326),
    'https://pier39.com',
    '415-555-0105',
    4.3
  ); 