require 'fastlane/action'
require_relative '../helper/flutter_ios_integrate_helper'

module Fastlane
  module Actions
    class FlutterIosIntegrateAction < Action
      def self.run(params)
        
        param_flutter_path = params[:flutter_project_path]
        param_xcodeproj_path = params[:xcodeproj_path]
        param_debug = params[:debug]

        UI.message(" ===== Flutter 构建开始 ===== ")

        # 清空未提交的内容 / 清空子模块为提交的内容
        Action.sh("git reset --hard;git submodule foreach --recursive git reset --hard")

        # 初始化 submodule
        other_action.git_submodule_update(recursive: true, init: true) 

        # 从远端更新 submodule
        Action.sh("git submodule update --remote")

        # Flutter 编译命令
        flutter_build_command = "cd " + param_flutter_path + ";flutter pub get"

        # Pub Get
        flutter_build_result = Action.sh(flutter_build_command)
        UI.message "#{flutter_build_result}"

        # Debug 打包时替换 Flutter build 模式命令
        # 以防 Debug 包中的 FLutter 引起闪退
        if param_debug
          UI.message(" +++ 修改 FLUTTER_BUILD_MODE +++ ")
          flutter_build_mode = "cd " + param_xcodeproj_path + ";sed -i '' 's/FLUTTER_BUILD_MODE = debug/FLUTTER_BUILD_MODE = release/g' project.pbxproj"
          Actions.sh(flutter_build_mode) # 将 Flutter 的 build 模式调整为 release，否则测试包闪退
        end
        sleep(5) # 等待 Flutter 更新

        UI.message(" ===== Flutter 构建结束 ===== ")

      end

      def self.description
        "Fastlane plugin to integrate flutter to existing iOS project"
      end

      def self.authors
        ["Akring"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :flutter_project_path,
                                  env_name: "",
                               description: "Flutter 项目的相对路径",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :xcodeproj_path,
                                  env_name: "",
                               description: "iOS 项目 xcodeproj 文件的相对路径，用于 Debug 打包模式下更改 FLUTTER_BUILD_MODE",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :debug,
                                  env_name: "",
                               description: "是否是 Debug 打包（Debug 模式下需执行 FLUTTER_BUILD_MODE 更改）",
                                  optional: true,
                                      type: Boolean)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
