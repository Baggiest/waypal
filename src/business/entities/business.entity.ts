import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';
import { Point } from 'geojson';

@Entity('businesses')
export class Business {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  description: string;

  @Column()
  address: string;

  @Column('geometry', {
    spatialFeatureType: 'Point',
    srid: 4326, // WGS84 coordinate system
  })
  location: Point;

  @Column({ nullable: true })
  website?: string;

  @Column({ nullable: true })
  phone?: string;

  @Column('decimal', { nullable: true, precision: 3, scale: 2 })
  rating?: number;

  // This is a virtual field that will be calculated during queries
  distance?: number;
} 