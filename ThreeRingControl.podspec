Pod::Spec.new do |s|
    s.name         = 'ThreeRingControl'
    s.version      = '1.0.0'
    s.summary      = 'A short description of ThreeRingControl.'
    s.homepage     = 'http://EXAMPLE/ThreeRingControl'
    s.license      = 'MIT'
    s.description  = 'The three-ring is used to populate the activity ring with colors. It has icons loaded to show the concentric circles.'
    s.author        = { 'Yoseph' => 'ytilahun@paypal.com' }
    s.homepage      = 'https://github.com/Yoseph-tilahun'
    s.platform      = :ios, '11.0'
    s.source       = { :git => 'https://github.com/Yoseph-tilahun/ThreeRingControl.git', :tag => '3.0.0' }
    s.source_files  = 'ThreeRingControl', 'ThreeRingControl/**/*.{h,m,swift}'
    s.resources     = 'ThreeRingControl/*.mp3'
    #s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end
