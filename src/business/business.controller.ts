import { Controller, Get, Query } from '@nestjs/common';
import { BusinessService } from './business.service';
import { SearchBusinessesDto } from './dto/search-businesses.dto';
import { Business } from './entities/business.entity';

@Controller('businesses')
export class BusinessController {
  constructor(private readonly businessService: BusinessService) {}

  @Get('search')
  async searchNearbyBusinesses(@Query() searchDto: SearchBusinessesDto): Promise<Business[]> {
    return this.businessService.searchNearbyBusinesses(searchDto);
  }
}
