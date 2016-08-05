Pod::Spec.new do |s|
s.name                = "MobAPI-For-iOS"
s.version             = "1.0.6"
s.summary             = 'mob.com MobAPI SDK'
s.license             = 'MIT'
s.author              = { "ShengQiangLiu" => "1365688791@qq.com" }
s.homepage            = 'http://www.mob.com'
s.source              = { :git => "https://github.com/MobClub/MobAPI-For-iOS.git", :tag => s.version.to_s }
s.platform            = :ios, '6.0'
s.vendored_frameworks = 'libraries/MobAPI.framework'
s.resources           = 'libraries/MobAPI.bundle'
end