import SwiftUI
import AVFoundation
import Combine

struct mindfulness: View {
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @State private var audioPlayer: AVAudioPlayer?
    @State private var currentTime: TimeInterval = 0.0
    @State private var totalTime: TimeInterval = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Mindfulness")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Image("mindfulness")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
                .padding(.horizontal, 30)
                .padding(.top, 30)
            
            Spacer()
            
            HStack(spacing: 50) {
                Button(action: {
                    audioPlayer?.currentTime -= 20
                }) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                }
                
                Button(action: {
                    if let player = audioPlayer {
                        if player.isPlaying {
                            player.pause()
                        } else {
                            player.play()
                        }
                        audioPlayerManager.isPlaying.toggle() // Toggle play/pause state
                    }
                }) {
                    Image(systemName: audioPlayerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    audioPlayer?.currentTime += 20
                }) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                }
            }
            .padding(.bottom, 20)
            
            HStack {
                Text(formatTime(time: currentTime))
                    .font(.title3)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                Text(formatTime(time: totalTime))
                    .font(.title3)
                    .padding(.horizontal, 30)
            }
            
            Slider(value: $currentTime, in: 0...totalTime)
                .disabled(true)
                .padding(.horizontal, 25)
                .padding(.bottom, 20)
        }
        .onAppear(perform: loadAudio)
        .onReceive(timer) { _ in
            if let player = audioPlayer, player.isPlaying {
                currentTime = player.currentTime
            }
        }
    }
    
    func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func loadAudio() {
        guard let soundURL = Bundle.main.url(forResource: "mindfulnessmed", withExtension: "mp3") else {
            fatalError("Failed to find audio file in the app bundle.")
        }
        
        audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
        if let player = audioPlayer {
            totalTime = player.duration
            currentTime = player.currentTime
        } else {
            fatalError("Failed to create audio player for audio file")
        }
    }
}

struct mindfulness_Previews: PreviewProvider {
    static var previews: some View {
        mindfulness()
    }
}
