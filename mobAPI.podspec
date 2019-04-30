Pod::Spec.new do |s|
	s.name                = 'mob_apisdk'
	s.version             = "2.1.1"
	s.summary             = 'mob.com MobAPI SDK'
	s.license             = 'MIT'
	s.author              = { "mob" => "mobproducts@163.com"}
	s.homepage            = 'http://www.mob.com'
	s.source              = { :git => "https://github.com/MobClub/MobAPI-For-iOS.git", :tag => s.version.to_s }
	s.platform            = :ios
	s.ios.deployment_target = "8.0"
	s.dependency 'MOBFoundation'
	s.vendored_frameworks = 'SDK/MobAPI/MobAPI.framework'
	s.resources           = 'SDK/MobAPI/MobAPI.bundle'

end
