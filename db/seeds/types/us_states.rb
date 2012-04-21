namspace :db do
  namespace :seed do

  desc "load US States "

  def load_us_states
      State.create_or_update({:abbreviation => 'AK', :fips_code => '02', :name => 'ALASKA'})
      State.create_or_update({:abbreviation => 'AL', :fips_code => '01', :name => 'ALABAMA'})
      State.create_or_update({:abbreviation => 'AR', :fips_code => '05', :name => 'ARKANSAS'})
      State.create_or_update({:abbreviation => 'AS', :fips_code => '60', :name => 'AMERICAN SAMOA'})
      State.create_or_update({:abbreviation => 'AZ', :fips_code => '04', :name => 'ARIZONA'})
      State.create_or_update({:abbreviation => 'CA', :fips_code => '06', :name => 'CALIFORNIA'})
      State.create_or_update({:abbreviation => 'CO', :fips_code => '08', :name => 'COLORADO'})
      State.create_or_update({:abbreviation => 'CT', :fips_code => '09', :name => 'CONNECTICUT'})
      State.create_or_update({:abbreviation => 'DC', :fips_code => '11', :name => 'DISTRICT OF COLUMBIA'})
      State.create_or_update({:abbreviation => 'DE', :fips_code => '10', :name => 'DELAWARE'})
      State.create_or_update({:abbreviation => 'FL', :fips_code => '12', :name => 'FLORIDA'})
      State.create_or_update({:abbreviation => 'GA', :fips_code => '13', :name => 'GEORGIA'})
      State.create_or_update({:abbreviation => 'GU', :fips_code => '66', :name => 'GUAM'})
      State.create_or_update({:abbreviation => 'HI', :fips_code => '15', :name => 'HAWAII'})
      State.create_or_update({:abbreviation => 'IA', :fips_code => '19', :name => 'IOWA'})
      State.create_or_update({:abbreviation => 'ID', :fips_code => '16', :name => 'IDAHO'})
      State.create_or_update({:abbreviation => 'IL', :fips_code => '17', :name => 'ILLINOIS'})
      State.create_or_update({:abbreviation => 'IN', :fips_code => '18', :name => 'INDIANA'})
      State.create_or_update({:abbreviation => 'KS', :fips_code => '20', :name => 'KANSAS'})
      State.create_or_update({:abbreviation => 'KY', :fips_code => '21', :name => 'KENTUCKY'})
      State.create_or_update({:abbreviation => 'LA', :fips_code => '22', :name => 'LOUISIANA'})
      State.create_or_update({:abbreviation => 'MA', :fips_code => '25', :name => 'MASSACHUSETTS'})
      State.create_or_update({:abbreviation => 'MD', :fips_code => '24', :name => 'MARYLAND'})
      State.create_or_update({:abbreviation => 'ME', :fips_code => '23', :name => 'MAINE'})
      State.create_or_update({:abbreviation => 'MI', :fips_code => '26', :name => 'MICHIGAN'})
      State.create_or_update({:abbreviation => 'MN', :fips_code => '27', :name => 'MINNESOTA'})
      State.create_or_update({:abbreviation => 'MO', :fips_code => '29', :name => 'MISSOURI'})
      State.create_or_update({:abbreviation => 'MS', :fips_code => '28', :name => 'MISSISSIPPI'})
      State.create_or_update({:abbreviation => 'MT', :fips_code => '30', :name => 'MONTANA'})
      State.create_or_update({:abbreviation => 'NC', :fips_code => '37', :name => 'NORTH CAROLINA'})
      State.create_or_update({:abbreviation => 'ND', :fips_code => '38', :name => 'NORTH DAKOTA'})
      State.create_or_update({:abbreviation => 'NE', :fips_code => '31', :name => 'NEBRASKA'})
      State.create_or_update({:abbreviation => 'NH', :fips_code => '33', :name => 'NEW HAMPSHIRE'})
      State.create_or_update({:abbreviation => 'NJ', :fips_code => '34', :name => 'NEW JERSEY'})
      State.create_or_update({:abbreviation => 'NM', :fips_code => '35', :name => 'NEW MEXICO'})
      State.create_or_update({:abbreviation => 'NV', :fips_code => '32', :name => 'NEVADA'})
      State.create_or_update({:abbreviation => 'NY', :fips_code => '36', :name => 'NEW YORK'})
      State.create_or_update({:abbreviation => 'OH', :fips_code => '39', :name => 'OHIO'})
      State.create_or_update({:abbreviation => 'OK', :fips_code => '40', :name => 'OKLAHOMA'})
      State.create_or_update({:abbreviation => 'OR', :fips_code => '41', :name => 'OREGON'})
      State.create_or_update({:abbreviation => 'PA', :fips_code => '42', :name => 'PENNSYLVANIA'})
      State.create_or_update({:abbreviation => 'PR', :fips_code => '72', :name => 'PUERTO RICO'})
      State.create_or_update({:abbreviation => 'RI', :fips_code => '44', :name => 'RHODE ISLAND'})
      State.create_or_update({:abbreviation => 'SC', :fips_code => '45', :name => 'SOUTH CAROLINA'})
      State.create_or_update({:abbreviation => 'SD', :fips_code => '46', :name => 'SOUTH DAKOTA'})
      State.create_or_update({:abbreviation => 'TN', :fips_code => '47', :name => 'TENNESSEE'})
      State.create_or_update({:abbreviation => 'TX', :fips_code => '48', :name => 'TEXAS'})
      State.create_or_update({:abbreviation => 'UT', :fips_code => '49', :name => 'UTAH'})
      State.create_or_update({:abbreviation => 'VA', :fips_code => '51', :name => 'VIRGINIA'})
      State.create_or_update({:abbreviation => 'VI', :fips_code => '78', :name => 'VIRGIN ISLANDS'})
      State.create_or_update({:abbreviation => 'VT', :fips_code => '50', :name => 'VERMONT'})
      State.create_or_update({:abbreviation => 'WA', :fips_code => '53', :name => 'WASHINGTON'})
      State.create_or_update({:abbreviation => 'WI', :fips_code => '55', :name => 'WISCONSIN'})
      State.create_or_update({:abbreviation => 'WV', :fips_code => '54', :name => 'WEST VIRGINIA'})
      State.create_or_update({:abbreviation => 'WY', :fips_code => '56', :name => 'WYOMING'})
  end
end