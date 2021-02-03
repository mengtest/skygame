--配置表模块初始化 GO
--@xcfg: [engine.develop.cfg.CfgMgr#CfgMgr]
function LoadCfgFile(xcfg)
    xcfg:AutoLoad(CFG)
end
--配置表模块初始化 END