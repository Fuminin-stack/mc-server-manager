-- setting parameters
DEFAULT={
  game_loader={
    value="fabric-server-mc.1.21.4-loader.0.16.10-launcher.1.0.1.jar",
    messages={
      entry="Enter game loader: ",
      retry="Invalid game loader option, retry.",
      success="The following game loader will be used to start the server: "
    }
  },
  memory_size={
    value=3072,
    messages={
      entry="Available memory (in M): ",
      retry=""
    }
  }
}

PRE_LAUNCH_MSG = "Launching Minecraft server from 'launch.lua'..."
