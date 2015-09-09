Pod::Spec.new do |spec|
  spec.name = 'PLVisualAttributeConstraints'
  spec.version =  '1.0.2'
  spec.summary =  "Custom VFL (Visual Format Language) for creating NSLayoutConstraint's."
  spec.description = 'Offers more readable and concise replacement for constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant: (NSLayoutConstraint, AutoLayout mechanism).'
  spec.homepage = 'https://github.com/Polidea/PLVisualAttributeConstraints'
  spec.license = {
    :type => 'BSD',
    :file => 'LICENSE'
  }
  spec.author = {
    "Polidea" => "kamil.jaworski@polidea.com"
  }
  spec.platform = :ios, '6.0'
  spec.source = {
    :git => "https://github.com/Polidea/PLVisualAttributeConstraints.git",
    :tag => spec.version.to_s 
  }
  spec.source_files = 'PLVisualAttributeConstraints/PLVisualAttributeConstraints/**/*.{h,m}'
  spec.requires_arc = true
  spec.deprecated_in_favor_of = 'PLXVisualAttributeConstraints'
end
