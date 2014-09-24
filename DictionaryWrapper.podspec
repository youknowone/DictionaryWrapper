Pod::Spec.new do |s|
  s.name         = "DictionaryWrapper"
  s.version      = "0.3"
  s.summary      = "Toolkit to generate wrapper classes for keyed subscript interfaces, including NSDictionary. Especially useful for JSON objects."
  s.description  = <<-DESC
                    This toolkit suggests an easy way to create wrapper classes for objects which supports keyed subscript interface.
                    It is especially useful for JSON handling.
                   DESC
  s.homepage     = "https://github.com/youknowone/DictionaryWrapper"
  s.license      = "2-clause BSD"
  s.author       = { "Jeong YunWon" => "jeong@youknowone.org" }
  s.source       = { :git => "https://github.com/youknowone/DictionaryWrapper.git", :tag => "0.3" }
  s.dependency "cdebug", "~> 0.1"
  s.requires_arc = true

  s.source_files = "DictionaryWrapper/*"
  s.public_header_files = "DictionaryWrapper/*.h"
  s.prefix_header_contents = '
#include <cdebug/debug.h>
#include <Foundation/Foundation.h>
    '
end
