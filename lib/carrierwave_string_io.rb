# Carrierwave requires #original_filename to be defined when using StringIO

class CarrierwaveStringIO < StringIO
  def original_filename

    # this can be anything, since the filename is later converted into a UUID
    'foobar.png'
  end
end