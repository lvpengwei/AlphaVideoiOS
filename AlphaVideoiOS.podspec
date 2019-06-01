Pod::Spec.new do |spec|
  spec.name         = "AlphaVideoiOS"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of AlphaVideoiOS."
  spec.description  = <<-DESC
  render video with alpha
                   DESC
  spec.homepage     = "#"
  spec.license      = "MIT"
  spec.author             = { "lvpengwei" => "pengwei.lv@gmail.com" }
  spec.source       = { :git => "#", :tag => "#{spec.version}" }
  
  spec.ios.deployment_target = '9.0'

  spec.source_files  = ["Classes/**/*.swift"]
end
