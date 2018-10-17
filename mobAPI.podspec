Pod::Spec.new do |s|
s.name                = "mobAPI"
s.version             = "2.1.1"
s.summary             = 'mob.com MobAPI SDK'
s.license             = 'MIT'
s.author              = { "mob" => "mobproducts@163.com"}
s.homepage            = 'http://www.mob.com'
s.source              = { :git => "https://github.com/MobClub/MobAPI-For-iOS.git", :tag => s.version.to_s }
s.platform            = :ios
s.ios.deployment_target = "8.0"
s.default_subspecs      = 'MobAPI'
s.dependency 'MOBFoundation'

s.subspec 'MobAPI' do |sp|
sp.vendored_frameworks = 'SDK/MobAPI/MobAPI.framework'
sp.resources           = 'SDK/MobAPI/MobAPI.bundle'
end
