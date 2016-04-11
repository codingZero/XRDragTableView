Pod::Spec.new do |s|

  s.name         = "XRDragTableView"
  s.version      = "0.1.0"
  s.summary      = "a tableView which can sequence by drag cell"

  s.homepage     = "https://github.com/codingZero/XRDragTableView"

  s.license      = "MIT"

  s.author       = { "codingZero" => "yd13150@vip.qq.com" }

  s.social_media_url = "http://www.jianshu.com/users/425e4eed60ca/latest_articles"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/codingZero/XRDragTableView.git", :tag => s.version }


  s.source_files  = "XRDragTableView/*.{h,m}"

  s.requires_arc = true

end
