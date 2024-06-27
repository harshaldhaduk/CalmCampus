import SwiftUI
import AVFoundation

struct sensory: View {
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var progress: Double = 0
    @State private var selectedButton: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Ambiance")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 60)
                    .padding(.horizontal, 10)
                    .id("Meditate")

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        Button(action: {
                            if self.selectedButton == "forest" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("forest")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("forest")
                                self.isPlaying = true
                                self.selectedButton = "forest"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("foresticon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "forest" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "water" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("water")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("water")
                                self.isPlaying = true
                                self.selectedButton = "water"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("watericon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "water" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "fire" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("fire")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("fire")
                                self.isPlaying = true
                                self.selectedButton = "fire"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("fireicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "fire" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "library" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("library")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("library")
                                self.isPlaying = true
                                self.selectedButton = "library"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("libraryicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "library" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                    }
                    .padding(.horizontal)
                    .padding(.bottom,5)
                }
                .background(Color(.blue))

                Divider()
                    .padding(.horizontal)

                Text("Animals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                    .id("Meditate")

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        Button(action: {
                            if self.selectedButton == "frogs" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("frogs")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("frogs")
                                self.isPlaying = true
                                self.selectedButton = "frogs"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("frogsicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "frogs" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "owl" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("owl")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("owl")
                                self.isPlaying = true
                                self.selectedButton = "owl"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("owlicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "owl" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "whale" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("whale")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("whale")
                                self.isPlaying = true
                                self.selectedButton = "whale"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("whaleicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "whale" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                    }
                    .padding(.horizontal)
                    .padding(.bottom,5)
                }

                Divider()
                    .padding(.horizontal)

                Text("Weather")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                    .id("Meditate")

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        Button(action: {
                            if self.selectedButton == "wind" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("wind")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("wind")
                                self.isPlaying = true
                                self.selectedButton = "wind"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("windicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "wind" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "rain" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("rain")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("rain")
                                self.isPlaying = true
                                self.selectedButton = "rain"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("rainicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "rain" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "thunder" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("thunder")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("thunder")
                                self.isPlaying = true
                                self.selectedButton = "thunder"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("thundericon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "thunder" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "hail" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("hail")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("hail")
                                self.isPlaying = true
                                self.selectedButton = "hail"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("hailicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "hail" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                    }
                    .padding(.horizontal)
                    .padding(.bottom,5)
                }

                Divider()
                    .padding(.horizontal)

                Text("Footsteps")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                    .id("Meditate")

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        Button(action: {
                            if self.selectedButton == "gravel" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("gravel")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("gravel")
                                self.isPlaying = true
                                self.selectedButton = "gravel"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("gravelicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "gravel" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "dirt" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("dirt")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("dirt")
                                self.isPlaying = true
                                self.selectedButton = "dirt"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("dirticon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "dirt" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "sand" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("sand")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("sand")
                                self.isPlaying = true
                                self.selectedButton = "sand"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("sandicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "sand" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "mud" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("mud")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("mud")
                                self.isPlaying = true
                                self.selectedButton = "mud"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("mudicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "mud" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "snow" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("snow")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("snow")
                                self.isPlaying = true
                                self.selectedButton = "snow"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("snowicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "snow" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                    }
                    .padding(.horizontal)
                    .padding(.bottom,5)
                }

                Divider()
                    .padding(.horizontal)

                Text("ASMR")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                    .id("Meditate")

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        Button(action: {
                            if self.selectedButton == "marble" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("marble")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("marble")
                                self.isPlaying = true
                                self.selectedButton = "marble"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("marbleicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "marble" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "keyboard" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("keyboard")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("keyboard")
                                self.isPlaying = true
                                self.selectedButton = "keyboard"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("keyboardicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "keyboard" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "foam" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("foam")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("foam")
                                self.isPlaying = true
                                self.selectedButton = "foam"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("foamicon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "foam" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                        Button(action: {
                            if self.selectedButton == "marker" {
                                if self.isPlaying {
                                    self.pauseAudio()
                                    self.isPlaying = false
                                } else {
                                    self.playAudio("marker")
                                    self.isPlaying = true
                                }
                            } else {
                                if self.isPlaying {
                                    self.pauseAudio()
                                }
                                self.playAudio("marker")
                                self.isPlaying = true
                                self.selectedButton = "marker"
                            }
                                                }) {
                                                    ZStack {
                                                        Image("markericon")
                                                            .resizable()
                                                            .clipped()
                                                            .cornerRadius(20)
                                                            .frame(width: 75, height: 75)

                                                        if self.selectedButton == "marker" && self.isPlaying {
                                                            Circle()
                                                                .trim(from: 0, to: CGFloat(self.progress))
                                                                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                                                .frame(width: 30, height: 30)
                                                                .rotationEffect(Angle(degrees: 90.0))
                                                                .animation(.linear, value: self.progress)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }
                    }
                   .padding(.horizontal)
                   .padding(.bottom,50)
                }
            }
        }
    }

    func playAudio(_ filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            print("Could not find audio file")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            isPlaying = true
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if let player = self.player {
                    self.progress = Double(player.currentTime) / player.duration
                    if player.currentTime >= player.duration {
                        timer.invalidate()
                        self.isPlaying = false
                    }
                }
            }
        } catch {
            print("Error playing audio: \(error)")
        }
    }

    func pauseAudio() {
        player?.pause()
        isPlaying = false
    }
}

struct sensory_Previews: PreviewProvider {
    static var previews: some View {
        sensory()
    }
}
