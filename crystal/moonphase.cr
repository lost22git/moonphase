def moonphase(unix_date : Float64) : Float64
  # Eccentricity of Earth's orbit
  eccent : Float64 = 0.016718

  # Ecliptic longitude of the Sun at epoch 1980.0
  elonge : Float64 = 278.833540

  # Ecliptic longitude of the Sun at perigee
  elongp : Float64 = 282.596403

  torad : Float64 = Math::PI / 180.0

  fixangle = ->(a : Float64) { ((a % 360.0) + 360.0) % 360.0 }

  # Calculation of the Sun's position
  day = (unix_date / 86400.0 + 2440587.5) - 2444238.5                     # Date within epoch
  m = torad * fixangle.call(((360.0 / 365.2422) * day) + elonge - elongp) # Convert from perigee co-ordinates to epoch 1980.0

  # Solve equation of Kepler
  e = m
  delta = 1.0
  while delta.abs > 1E-6
    delta = e - eccent * Math.sin(e) - m
    e = e - delta / (1.0 - eccent * Math.cos(e))
  end

  # True anomaly
  ec = e
  ec = 2.0 * Math.atan(Math.sqrt((1.0 + eccent) / (1.0 - eccent)) * Math.tan(ec / 2.0))

  # Sun's geocentric ecliptic longitude
  lambdasun = fixangle.call(((ec) * (180.0 / Math::PI)) + elongp)

  # Moon's mean lonigitude at the epoch
  ml = fixangle.call(13.1763966 * day + 64.975464)

  # 349:  Mean longitude of the perigee at the epoch, Moon's mean anomaly
  mm = fixangle.call(ml - 0.1114041 * day - 349.383063)

  #  Evection
  ev = 1.2739 * Math.sin(torad * (2.0 * (ml - lambdasun) - mm))

  # Annual equation
  ae = 0.1858 * Math.sin(m)

  # Corrected anomaly
  mmp = torad * (mm + ev - ae - (0.37 * Math.sin(m)))

  # Corrected longitude
  lp = ml + ev + (6.2886 * Math.sin(mmp) - ae + (0.214 * Math.sin(2.0 * mmp)))

  # True longitude
  lpp = lp + (0.6583 * Math.sin(torad * (2.0 * (lp - lambdasun))))

  # Age of the Moon in degrees
  moonage = lpp - lambdasun

  moonage * torad
end
