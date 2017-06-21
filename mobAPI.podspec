Pod::Spec.new do |s|
s.name                = "mobAPI"
s.version             = "2.0.1"
s.summary             = 'mob.com MobAPI SDK'
s.license             = 'MIT'
s.author              = { "qc123456" => "vhbvbqc@gmail.com" }
s.homepage            = 'http://www.mob.com'
s.source              = { :git => "https://github.com/MobClub/MobAPI-For-iOS.git", :tag => s.version.to_s }
s.platform            = :ios, '7.0'
s.libraries           = "z", "stdc++"
s.vendored_frameworks = 'MobProducts/SDK/MobAPI/MobAPI.framework'
s.resources           = 'MobProducts/Sample/MobAPIDemo/Sample/Sources/MobAPI.bundle'
s.dependency 'MOBFoundation'
end
