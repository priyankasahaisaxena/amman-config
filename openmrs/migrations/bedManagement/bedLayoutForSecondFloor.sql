SELECT location_id INTO @location FROM location WHERE location.name='General ward (2nd floor)';

INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 1, 1, 5);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUE (@location, 1, 2, 4);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 1, 3, 3);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 1, 4, 2);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 1, 5, 1);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 1, 6, 16);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 1, 7, 17);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 2, 1, 6);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 2, 2, 8);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 2, 3, 10);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 2, 4, 12);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 2, 5, 14);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 2, 6, 18);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 2, 7, 19);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 3, 1, 7);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 3, 2, 9);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 3, 3, 11);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 3, 4, 13);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 3, 5, 15);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 3, 6, 20);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 3, 7, 21);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 4, 6, 22);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 4, 7, 23);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 5, 6, 24);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 5, 7, 25);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 6, 6, 26);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 6, 7, 27);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 7, 6, 28);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 7, 7, 29);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 8, 6, 30);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 8, 7, 31);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 9, 6, 32);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 9, 7, 33);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 10, 6, 34);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 10, 7, 35);
INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@location, 11, 6, 36);
