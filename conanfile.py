from conans import ConanFile, MSBuild, VisualStudioBuildEnvironment, tools
import sys, os, platform
from conans.util.files import tmp_file

class QmlViewerSetup(ConanFile):
  name = "QmlViewer"

  settings = "os", "compiler", "build_type", "arch"
  requires = "Qt/5.5.1@common/stable", "QmlExtension/1.0.0@common/stable"
  
  def imports(self):
    QtDir = self.deps_cpp_info['Qt'].rootpath;
    self.output.warn('QtDir = ' + QtDir);
    
    self.copy("*.dll", dst="plugin\\Tulip", src="plugin\\Tulip", root_package="QmlExtension")
    self.copy("qmldir", dst="plugin\\Tulip", src="plugin\\Tulip", root_package="QmlExtension")
    
    self.run('"{0}\\bin\\qmlplugindump.exe" Tulip 1.0 ./plugin > ./plugin/Tulip/plugins.qmltypes'.format(QtDir))


