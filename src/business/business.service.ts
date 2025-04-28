import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Business } from './entities/business.entity';
import { SearchBusinessesDto } from './dto/search-businesses.dto';

@Injectable()
export class BusinessService {
  constructor(
    @InjectRepository(Business)
    private businessRepository: Repository<Business>,
  ) {}

  /**
   * Search for businesses near the given coordinates
   * Uses PostGIS ST_Distance to calculate distances and ST_MakePoint to create points
   * @param searchDto Contains latitude and longitude
   * @returns Array of businesses sorted by distance
   */
  async searchNearbyBusinesses(searchDto: SearchBusinessesDto): Promise<Business[]> {
    const { latitude, longitude } = searchDto;
    
    // This query will:
    // 1. Create a point from the search coordinates
    // 2. Calculate distance using ST_Distance
    // 3. Order results by distance
    return this.businessRepository
      .createQueryBuilder('business')
      .select('business.*')
      .addSelect(
        `ST_Distance(
          business.location::geography,
          ST_SetSRID(ST_MakePoint(:longitude, :latitude), 4326)::geography
        ) as distance`,
      )
      .setParameters({
        latitude,
        longitude,
      })
      .orderBy('distance', 'ASC')
      .getRawMany();
  }
} 