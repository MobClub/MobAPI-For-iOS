Pod::Spec.new do |s|
	s.name                = 'mob_apisdk'
	s.version             = "2.1.6"
	s.summary             = 'mob.com MobAPI SDK'
	s.license             = 'MIT'
	s.author              = { "mob" => "mobproducts@163.com"}
	s.homepage            = 'http://www.mob.com'
	s.source              = { :http => 'https://dev.ios.mob.com/files/download/mobapi/MOBAPI_For_iOS_v2.1.6.zip' }
	s.platform            = :ios
	s.ios.deployment_target = "8.0"
	s.dependency 'MOBFoundation'
	s.vendored_frameworks = 'MobAPI/MobAPI.framework'
	s.resources           = 'MobAPI/MobAPI.bundle'

end
