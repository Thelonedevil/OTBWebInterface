


class References
  require 'java'
  java_import java.lang.System
  ::DIR_BASE = System.getProperty("OTBBASE","#{Dir.home}/.otbproject")
end