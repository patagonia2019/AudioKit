//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
//:
//: ---
//:
//: ## High Pass Filter
//: ### A high-pass filter takes an audio signal as an input, and cuts out the
//: ### low-frequency components of the audio signal, allowing for the higher frequency
//: ### components to "pass through" the filter.
//:
import XCPlayground
import AudioKit

let file = try AKAudioFile(readFileName: "mixloop.wav", baseDir: .Resources)

let player = try AKAudioPlayer(file: file)
player.looping = true

var highPassFilter = AKHighPassFilter(player)

//: Set the parameters here
highPassFilter.cutoffFrequency = 6900 // Hz
highPassFilter.resonance = 0 // dB

AudioKit.output = highPassFilter
AudioKit.start()
player.play()

//: User Interface Set up

class PlaygroundView: AKPlaygroundView {

    //: UI Elements we'll need to be able to access
    var cutoffFrequencyLabel: Label?
    var resonanceLabel: Label?

    override func setup() {
        addTitle("High Pass Filter")

        addButtons()

        addLabel("High Pass Filter Parameters")

        addButton("Process", action: #selector(process))
        addButton("Bypass", action: #selector(bypass))

        cutoffFrequencyLabel = addLabel("Cut-off Frequency: 6900 Hz")
        addSlider(#selector(setCutoffFrequency), value: 6900, minimum: 10, maximum: 22050)

        resonanceLabel = addLabel("Resonance: 0 dB")
        addSlider(#selector(setResonance), value: 0, minimum: -20, maximum: 40)

    }

    //: Handle UI Events

    override func startLoop(name: String) {
        player.stop()
        let file = try? AKAudioFile(readFileName: "\(name)", baseDir: .Resources)
        try? player.replaceFile(file!)
        player.play()
    }
    override func stop() {
        player.stop()
    }

    func process() {
        highPassFilter.start()
    }

    func bypass() {
        highPassFilter.bypass()
    }

    func setCutoffFrequency(slider: Slider) {
        highPassFilter.cutoffFrequency = Double(slider.value)
        let cutoffFrequency = String(format: "%0.1f", highPassFilter.cutoffFrequency)
        cutoffFrequencyLabel!.text = "Cut-off Frequency: \(cutoffFrequency) Hz"
        printCode()
    }

    func setResonance(slider: Slider) {
        highPassFilter.resonance = Double(slider.value)
        let resonance = String(format: "%0.1f", highPassFilter.resonance)
        resonanceLabel!.text = "Resonance: \(resonance) dB"
        printCode()
    }

    func printCode() {
        // Here we're just printing out the preset so it can be copy and pasted into code

        Swift.print("public func presetXXXXXX() {")
        Swift.print("    cutoffFrequency = " +
            String(format: "%0.3f", highPassFilter.cutoffFrequency))
        Swift.print("    resonance = \(String(format: "%0.3f", highPassFilter.resonance))")
        Swift.print("}\n")
    }
}

let view = PlaygroundView(frame: CGRect(x: 0, y: 0, width: 500, height: 550))
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = view

//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)