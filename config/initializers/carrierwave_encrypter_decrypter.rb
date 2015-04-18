Carrierwave::EncrypterDecrypter.configure  do |config|
    
    #This strategy is applicable when you planning for a AES Encrytion
    #Read more about it here http://ruby-doc.org/stdlib-2.0/libdoc/openssl/rdoc/OpenSSL.html#module-OpenSSL-label-Encryption
    config.encryption_type = :aes
    config.key_size = 256

    #This strategy is applicable when you want to have the pkcs5 (Password based encryption)
    #config.encryption_type = :pkcs5
    #config.key_size = 256
 end
