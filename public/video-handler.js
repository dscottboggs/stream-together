const Play = new Symbol("play the video");
const Pause = new Symbol("pause the video");
const Join = new Symbol('join the server session');
const Ready = new Symbol('indictate the player is ready');
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
      plugins: {
        eventTracking: true
      }
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

  onVideoLoad() {
    if (this.loadStartTime !== null) this.postStats(new Date().getTime() - this.loadStartTime);
    this.sendCommandToServer(Ready);
  }
  onPlayerPaused() {
    this.sendCommandToServer(Pause)
  }
  onPlayerResumed() {
    this.sendCommandToServer(Play);
  }
  onPlayerStalled(){
    this.sendCommandToServer(Pause, this.player.currentTime());
  }
  onServerCommand(command) {
    switch (command.data) {
      case "play":
        this.player.play();
        break;
      default:
        console.error(`unknown command from server ${command.data}`);
    }
  }
  sendCommandToServer(command) {
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