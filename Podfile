# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SchoolProject' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'FBSDKLoginKit'

  # Pods for SchoolProject
  def testing_pods
  pod 'Quick'
  pod 'Nimble'
  end

  target 'SchoolProjectTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'FBSDKLoginKit'
    testing_pods
  end

  target 'SchoolProjectUITests' do
    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

end
