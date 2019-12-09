*******************************************
**  RT2012 Weather Data for BuildSysPro  **
*******************************************
(https://www.rt-batiment.fr/batiments-neufs/reglementation-thermique-2012/donnees-meteorologiques.html)

- Public data
- Typical Meteorological Years (representative of a typical year, designed according to the NF EN ISO 15927-4)
- Reference period : from january 1994 to december 2008
- /!\ Data are given at sea level (i.e. altitude = 0 m). Altitude correction should be applied for other altitudes.
- Temperature at 1m deep in the soil is used as a reference for the cold water temperature
- Data are given in solar time

- The files are designed to be used with BuildSysPro Meteofile model.
The columns are :
	Time(s)
	FDIRN(W/m2) - direct normal solar irradiance
	FDIFH(W/m2) - diffuse horizontal solar irradiance
	Tdry(°C) - dry air temperature
	Tdew(°C) - dew point temperature
	Tsky(°C) - sky temperature
	Patm(Pa) - atmospheric pressure
	RH(0..1) - relative humidity
	WindSpeed(m/s) - wind speed
	WindDir(°) - wind direction
	Lat(°) - latitude
	Lon(°) - longitude
