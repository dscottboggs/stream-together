const Play = new Symbol("play the video");
const Pause = new Symbol("pause the video");
const Join = new Symbol('join the server session');
const Ready = new Symbol('indictate the player is ready');
const Load = new Symbol('load the video');
const DEBUG = true;

class SocketNotReady extends Exception {
  constructor(socket) {
    super(`socket was not yet ready, it's status was ${this.errorString(socket.readyState)} `)
  }
  errorString(readyState) {
    switch (readyState) {
      case WebSocket.CONNECTING:
        return "WebSocket.CONNECTING";
        break;
      case WebSocket.OPEN:
        throw Exception.new("While raising SocketNotReady error, the socket was ready? wtf...")
        break;
      case WebSocket.CLOSING:
        return "WebSocket.CLOSING";
        break;
      case WebSocket.CLOSED:
        return "WebSocket.CLOSED";
        break;
      default:
        return `unknown state ${readyState}`
    }
  }
}

class UnknownCommandError extends Exception {
  constructor(command) {
    super("recevied unknown command " + command + ".");
  }
}

class ServerCommand {
  constructor(json) {
    const parsed = JSON.parse(json);
    for( var prop in parsed ) {
      if(parsed.hasOwnProperty(prop)) this[prop] = parsed[prop]
    }
  }
  set command(cmd) {
    switch (cmd) {
      case "play":
        this.command = Play;
        break;
      case "pause":
        this.command = Pause;
        break;
      case "load":
        this.command = Load;
        break;
      default:
        throw new UnknownCommandError(cmd)
    }
  }
}

class VideoPlayer {
  constructor(sourceURL) {
    this.loadStartTime = null;
    try {
      this.sourceURL = encodeURI(sourceURL);
    } catch (e) {
      if( e.prototype == URIError()) {
        if( DEBUG ) throw e;
        alert(`Invalid URL specified: ${sourceURL}`)
      }
    }
    this.setupSocket();
    this.setupPlayer();
    this.sendCommandToServer(Join);
  }

  get options() {
    return {
      preload: 'auto',
      autoplay: false,
      src: this.sourceURL,
      // playbackRates: [ 0.5, 0.75, 0.85, 1, 1.15, 1.25, 1.33, 1.5 ],
      // TODO: allow changing synchronized playbackRates, if possible
    };
  }

  get socketOptions() {
    return JSON.stringify({
      source: this.sourceURL
    });
  }
  setupSocket() {
    this.socket = new WebSocket("/", this.socketOptions);
    this.socket.onopen = function() {
      this.socket.onmessage = this.onServerCommand;
    }
  }


  setupPlayer() {
    this.player = videojs("video-js-target-tag", this.options, this.onVideoLoad);
    this.player.on(
      'loadstart',
      () => {
        this.loadStartTime = new Date().getTime()
      }
    );
    this.player.on('play', this.onPlayerResumed);
    this.player.on('pause', this.onPlayerPaused);
    this.player.on('ready', this.onVideoLoad);
    this.player.on('stalled', this.onPlayerStalled);
  }
  // called when the video has finished loading
  onVideoLoad() {
    if (this.loadStartTime !== null) this.postStats(new Date().getTime() - this.loadStartTime);
    this.sendCommandToServer(Ready);
  }
  // called when the pause button is clicked
  onPlayerPaused() {
    this.sendCommandToServer(Pause, this.player.currentTime())
  }
  // called when the play button is clicked
  onPlayerResumed() {
    this.sendCommandToServer(Play);
  }
  // called when playing has paused to allow buffering.
  onPlayerStalled(){
    this.sendCommandToServer(Pause, this.player.currentTime());
  }
  // Called when a command is received from the server.
  onServerCommand(command) {
    switch (command.data.slice(0, 4)) {
      case "play":
        if(command.data.size > 4) {

        }
        this.player.play();
        break;
      default:
        console.error(`unknown command from server ${command.data}`);
    }
  }
  // send the given command to the server, with an optional payload.
  sendCommandToServer(command, payload) {
    if( this.socket.readyState !== WebSocket.OPEN) throw new SocketNotReady(this.socket);
    switch (command) {
      case Play:

        break;
      case Pause:

        break;
      case Join:

        break;
      case Ready:

        break;
      default:
        log.error(`Got invalid command ${command}`)
    }
  }
}
