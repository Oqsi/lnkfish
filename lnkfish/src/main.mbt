// 游戏主入口函数
// 初始化游戏引擎并注册所有系统
fn main {
  // 获取动态Canvas尺寸(由HTML传入,如果未设置则使用设计尺寸)
  let canvas_width = get_viewport_width()
  let canvas_height = get_viewport_height()
  
  // 创建游戏应用实例并配置基本参数
  @system.App::new()
    .with_canvas_width(canvas_width)
    .with_canvas_height(canvas_height)
    .with_image_smooth(true)  // 启用图像平滑
    .with_fps(60)  // 设置游戏帧率为60fps
    .add_plugin(@plugins.default_plugin)  // 添加默认插件(包含渲染、输入、碰撞检测等)
    // 启动时初始化系统
    .add_system(game_start, schedule=@system.Schedule::Startup)
    // 以下系统在每帧更新时执行
    .add_system(loading_system, schedule=@system.Schedule::Update)  // 加载界面系统
    .add_system(main_menu_system, schedule=@system.Schedule::Update)  // 主菜单系统
    .add_system(level_select_system, schedule=@system.Schedule::Update)  // 关卡选择系统
    .add_system(game_settings_system, schedule=@system.Schedule::Update)  // 游戏设置系统
    .add_system(help_system, schedule=@system.Schedule::Update)  // 帮助界面系统
    .add_system(leaderboard_system, schedule=@system.Schedule::Update)  // 排行榜系统
    .add_system(prepare_game_system, schedule=@system.Schedule::Update)  // 游戏准备系统
    .add_system(handle_help_input_system, schedule=@system.Schedule::Update)  // 帮助界面输入处理
    .add_system(handle_input, schedule=@system.Schedule::Update)  // 游戏输入处理(旋转控制)
    .add_system(update_rotation, schedule=@system.Schedule::Update)  // 双鱼旋转更新
    .add_system(flow_mode_system, schedule=@system.Schedule::Update)  // 心流模式系统
    .add_system(process_collision, schedule=@system.Schedule::Update)  // 障碍物碰撞检测
    .add_system(process_taiji_collision, schedule=@system.Schedule::Update)  // 太极符碰撞检测
    .add_system(time_scoring_system, schedule=@system.Schedule::Update)  // 时间计分系统
    .add_system(obstacle_system, schedule=@system.Schedule::Update)  // 障碍物生成系统
    .add_system(taiji_system, schedule=@system.Schedule::Update)  // 太极符生成系统
    .add_system(ui_system, schedule=@system.Schedule::Update)  // UI界面渲染系统
    .add_system(button_hover_system, schedule=@system.Schedule::Update)  // 按钮悬停效果系统
    .run()
}
