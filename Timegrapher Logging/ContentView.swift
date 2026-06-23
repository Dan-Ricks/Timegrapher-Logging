//
//  ContentView.swift
//  Timegrapher Logging
//
//  Created by Dan on 6/22/26.
//

import SwiftUI
import Photos
import UIKit

struct PositionData: Codable {
    var rate: String = ""
    var amplitude: String = ""
    var beatError: String = ""
}

struct ContentView: View {
    private let mainPositions = ["Dial Up", "Dial Down", "Crown Down", "Crown Left", "Crown Up", "Crown Right"]
    private let diagonalPositions = ["Crown Up Left", "Crown Up Right", "Crown Down Left", "Crown Down Right"]

    private var positions: [String] {
        includeDiagonals ? mainPositions + diagonalPositions : mainPositions
    }

    private var verticalPositions: [String] {
        var v = ["Crown Down", "Crown Left", "Crown Up", "Crown Right"]
        if includeDiagonals {
            v += ["Crown Down Left", "Crown Down Right", "Crown Up Left", "Crown Up Right"]
        }
        return v
    }

    let liftOptions = ["50", "52", "53"]
    let beatOptions = ["18000", "21600", "28800"]

    @State private var selectedLift = "52"
    @State private var customLift = ""
    @State private var useCustomLift = false

    @State private var selectedBeat = "28800"
    @State private var customBeat = ""
    @State private var useCustomBeat = false

    @State private var includeDiagonals = false

    @State private var timepiece = ""

    @State private var readings: [String: PositionData] = [:]

    @State private var isSaving = false
    @State private var showSavedAlert = false

    private var currentLiftAngle: Double {
        if useCustomLift, let val = Double(customLift) { return val }
        return Double(selectedLift) ?? 52.0
    }

    private var currentBeatRate: Int {
        if useCustomBeat, let val = Double(customBeat) { return Int(val) }
        return Int(selectedBeat) ?? 28800
    }

    private var computedRates: [String: Double] {
        var dict: [String: Double] = [:]
        for pos in positions {
            if let data = readings[pos], let r = Double(data.rate) {
                dict[pos] = r
            }
        }
        return dict
    }

    private var averageRate: Double {
        let vals = Array(computedRates.values)
        return vals.isEmpty ? 0 : vals.reduce(0, +) / Double(vals.count)
    }

    private var maxDelta: Double {
        let vals = Array(computedRates.values)
        guard let max = vals.max(), let min = vals.min() else { return 0 }
        return max - min
    }

    private var computedAmplitudes: [String: Double] {
        var dict: [String: Double] = [:]
        for pos in positions {
            if let data = readings[pos], let a = Double(data.amplitude) {
                dict[pos] = a
            }
        }
        return dict
    }

    private var maxAmpDelta: Double {
        let vals = Array(computedAmplitudes.values)
        guard let max = vals.max(), let min = vals.min() else { return 0 }
        return max - min
    }

    private var horizontalAvg: Double {
        let vals = ["Dial Up", "Dial Down"].compactMap { computedRates[$0] }
        return vals.isEmpty ? 0 : vals.reduce(0, +) / Double(vals.count)
    }

    private var verticalAvg: Double {
        let vals = ["Crown Down", "Crown Left", "Crown Up", "Crown Right"].compactMap { computedRates[$0] }
        return vals.isEmpty ? 0 : vals.reduce(0, +) / Double(vals.count)
    }

    private var verticalDrop: Double {
        horizontalAvg - verticalAvg
    }

    private var fastestVerticalPosition: String? {
        let verticals = verticalPositions
        var best: (position: String, rate: Double)?
        for pos in verticals {
            if let rate = computedRates[pos] {
                if best == nil || rate > best!.rate {
                    best = (pos, rate)
                }
            }
        }
        return best?.position
    }

    private var hasVerticalRates: Bool {
        verticalPositions.contains { computedRates[$0] != nil }
    }

    private func binding(for position: String, keyPath: WritableKeyPath<PositionData, String>) -> Binding<String> {
        Binding(
            get: { readings[position]?[keyPath: keyPath] ?? "" },
            set: { newVal in
                var data = readings[position] ?? PositionData()
                data[keyPath: keyPath] = newVal
                readings[position] = data
            }
        )
    }

    private func initializeReadings() {
        for pos in positions {
            if readings[pos] == nil {
                readings[pos] = PositionData()
            }
        }
    }

    private func formatBPH(_ bph: String) -> String {
        if let num = Int(bph) {
            let f = NumberFormatter()
            f.numberStyle = .decimal
            return (f.string(from: NSNumber(value: num)) ?? bph) + " bph"
        }
        return bph + " bph"
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func saveToCameraRoll() {
        isSaving = true
        DispatchQueue.main.async {
            guard let image = self.generateExportImageSync() else {
                self.isSaving = false
                return
            }
            self._saveImageToPhotos(image) { success in
                DispatchQueue.main.async {
                    self.isSaving = false
                    if success {
                        self.showSavedAlert = true
                    }
                }
            }
        }
    }

    private func padLeft(_ str: String, width: Int) -> String {
        if str.count >= width { return str }
        return str + String(repeating: " ", count: width - str.count)
    }

    private func padRight(_ str: String, width: Int) -> String {
        if str.count >= width { return str }
        return String(repeating: " ", count: width - str.count) + str
    }

    private func generateExportImageSync() -> UIImage? {
        var lines: [String] = []

        // Timepiece
        if !timepiece.isEmpty {
            lines.append("Timepiece / Movement: \(timepiece)")
        } else {
            lines.append("Timepiece / Movement: (not entered)")
        }
        lines.append("")

        // Session Parameters
        let liftDisplay: String
        if useCustomLift && !customLift.isEmpty {
            liftDisplay = "\(customLift)° (custom)"
        } else {
            liftDisplay = "\(selectedLift)°"
        }
        let beatDisplay: String
        if useCustomBeat && !customBeat.isEmpty {
            beatDisplay = "\(customBeat) bph (custom)"
        } else {
            beatDisplay = formatBPH(selectedBeat)
        }
        lines.append("Lift Angle: \(liftDisplay)")
        lines.append("Beat Rate: \(beatDisplay)")
        lines.append("")

        // Position Readings - full table format (safe padding to avoid %s crashes on older devices)
        lines.append("Position Readings")
        lines.append(String(repeating: "-", count: 55))
        lines.append(padLeft("Orientation", width: 18) + " " + padRight("Rate (s/d)", width: 12) + " " + padRight("Amplitude", width: 10) + " " + padRight("Beat Err", width: 10))
        lines.append(String(repeating: "-", count: 55))

        for pos in positions {
            let data = readings[pos] ?? PositionData()
            let rateStr = data.rate.isEmpty ? "" : data.rate
            let ampStr = data.amplitude.isEmpty ? "" : data.amplitude
            let errStr = data.beatError.isEmpty ? "" : data.beatError
            lines.append(padLeft(pos, width: 18) + " " + padRight(rateStr, width: 12) + " " + padRight(ampStr, width: 10) + " " + padRight(errStr, width: 10))
        }

        // Largest Delta row (always shown)
        let deltaRateStr = computedRates.isEmpty ? "" : String(format: "+%.2f", maxDelta)
        let deltaAmpStr = computedAmplitudes.isEmpty ? "" : String(format: "+%.0f", maxAmpDelta)
        lines.append(padLeft("Largest Delta", width: 18) + " " + padRight(deltaRateStr, width: 12) + " " + padRight(deltaAmpStr, width: 10) + " " + padRight("", width: 10))
        lines.append("")

        // Results
        lines.append("Results")
        lines.append("Average Rate: \(String(format: "%.2f", averageRate)) s/d")
        lines.append("Max Delta: \(String(format: "%.2f", maxDelta)) s/d")
        lines.append("Horizontal Avg: \(String(format: "%.2f", horizontalAvg)) s/d")
        lines.append("Vertical Avg: \(String(format: "%.2f", verticalAvg)) s/d")
        lines.append("Horizontal vs Vertical Drop: \(String(format: "%.2f", verticalDrop)) s/d")

        // Draw the image - use monospace for table alignment
        let font = UIFont.systemFont(ofSize: 13)
        let monoFont = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        let titleFont = UIFont.boldSystemFont(ofSize: 16)
        let headerFont = UIFont.boldSystemFont(ofSize: 13)
        let lineHeight: CGFloat = 17
        let width: CGFloat = 500
        let padding: CGFloat = 10
        let height = CGFloat(lines.count) * lineHeight + padding * 2 + 30

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: width, height: height))

            var y = padding
            for (index, line) in lines.enumerated() {
                let f: UIFont
                if line.contains("Position Readings") || line.contains("Results") || line.hasPrefix("---") {
                    f = headerFont
                } else if line.contains("Orientation") || line.contains("Largest Delta") || line.contains("Crown") || line.contains("Dial") {
                    f = monoFont
                } else {
                    f = font
                }
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: f,
                    .foregroundColor: UIColor.black
                ]
                let attributed = NSAttributedString(string: line, attributes: attrs)
                attributed.draw(at: CGPoint(x: padding, y: y))
                y += lineHeight
            }
        }
    }

    private func _saveImageToPhotos(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else {
                print("Photo library permission denied")
                completion(false)
                return
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                if let error = error {
                    print("Save to photos failed: \(error.localizedDescription)")
                }
                completion(success)
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Timepiece / Movement", text: $timepiece)
                        .autocapitalization(.words)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }

                // Lift Angle + Beat Rate (no "Session Parameters" header)
                Section {
                    // Lift Angle
                    Picker("Lift Angle", selection: $selectedLift) {
                        ForEach(liftOptions, id: \.self) { opt in
                            Text(opt + "°").tag(opt)
                        }
                        Text("Custom").tag("Custom")
                    }
                    .onChange(of: selectedLift) { oldVal, newVal in
                        if newVal == "Custom" {
                            useCustomLift = true
                            if customLift.isEmpty {
                                customLift = oldVal
                            }
                        } else {
                            useCustomLift = false
                        }
                    }

                    if useCustomLift {
                        // Compact custom entry (no full label to save space)
                        HStack(spacing: 4) {
                            Spacer()
                            TextField("52", text: $customLift)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 70)
                            Text("°")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                        }
                    }

                    // Beat Rate
                    Picker("Beat Rate", selection: $selectedBeat) {
                        ForEach(beatOptions, id: \.self) { opt in
                            Text(formatBPH(opt)).tag(opt)
                        }
                        Text("Custom").tag("Custom")
                    }
                    .onChange(of: selectedBeat) { oldVal, newVal in
                        if newVal == "Custom" {
                            useCustomBeat = true
                            if customBeat.isEmpty {
                                customBeat = oldVal
                            }
                        } else {
                            useCustomBeat = false
                        }
                    }

                    if useCustomBeat {
                        // Compact custom entry (no full label to save space)
                        HStack(spacing: 4) {
                            Spacer()
                            TextField("28800", text: $customBeat)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            Text("bph")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                        }
                    }
                }

                // Table for position readings (no spacing between rows, sized to fit, no cell borders)
                Section("Position Readings") {
                    VStack(spacing: 0) {
                        // Header row - tap header to dismiss keyboard
                        HStack(spacing: 0) {
                            Text("Orientation")
                                .frame(width: 98, alignment: .leading)
                                .font(.system(size: 15, weight: .bold))
                                .padding(.vertical, 2)
                                .padding(.horizontal, 2)
                                .background(Color.gray.opacity(0.2))

                            Text("Rate (s/d)")
                                .frame(width: 88, alignment: .trailing)
                                .font(.system(size: 15, weight: .bold))
                                .padding(.vertical, 2)
                                .padding(.horizontal, 2)
                                .background(Color.gray.opacity(0.2))

                            Text("Amplitude")
                                .frame(width: 88, alignment: .trailing)
                                .font(.system(size: 15, weight: .bold))
                                .padding(.vertical, 2)
                                .padding(.horizontal, 2)
                                .background(Color.gray.opacity(0.2))

                            Text("Beat Err")
                                .frame(width: 88, alignment: .trailing)
                                .font(.system(size: 15, weight: .bold))
                                .padding(.vertical, 2)
                                .padding(.horizontal, 2)
                                .background(Color.gray.opacity(0.2))
                        }
                        .onTapGesture {
                            hideKeyboard()
                        }

                        // Data rows
                        ForEach(positions, id: \.self) { position in
                            HStack(spacing: 0) {
                                Text(position)
                                    .frame(width: 98, alignment: .leading)
                                    .font(.system(size: 15))
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 2)
                                    .onTapGesture {
                                        hideKeyboard()
                                    }

                                TextField("0.0", text: binding(for: position, keyPath: \.rate))
                                    .keyboardType(.numbersAndPunctuation)
                                    .multilineTextAlignment(.trailing)
                                    .font(.system(size: 15))
                                    .frame(width: 88, alignment: .trailing)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 2)

                                TextField("0", text: binding(for: position, keyPath: \.amplitude))
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .font(.system(size: 15))
                                    .frame(width: 88, alignment: .trailing)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 2)

                                TextField("0.0", text: binding(for: position, keyPath: \.beatError))
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .font(.system(size: 15))
                                    .frame(width: 88, alignment: .trailing)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 2)
                            }
                        }

                        // Hidden row at the bottom for largest delta (shown only when calculated)
                        HStack(spacing: 0) {
                            Text("Largest Delta")
                                .frame(width: 98, alignment: .leading)
                                .font(.system(size: 15, weight: .bold))
                                .padding(.vertical, 2)
                                .padding(.horizontal, 2)
                                .background(Color.gray.opacity(0.05))
                                .onTapGesture {
                                    hideKeyboard()
                                }

                            if !computedRates.isEmpty {
                                Text("+" + String(format: "%.2f", maxDelta))
                                    .frame(width: 88, alignment: .trailing)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 2)
                                    .background(Color.gray.opacity(0.05))
                                    .font(.system(size: 15))
                            } else {
                                Text("")
                                    .frame(width: 88, alignment: .trailing)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 2)
                                    .background(Color.gray.opacity(0.05))
                            }

                            if !computedAmplitudes.isEmpty {
                                Text("+" + String(format: "%.0f", maxAmpDelta))
                                    .frame(width: 88, alignment: .trailing)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 2)
                                    .background(Color.gray.opacity(0.05))
                                    .font(.system(size: 15))
                            } else {
                                Text("")
                                    .frame(width: 88, alignment: .trailing)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 2)
                                    .background(Color.gray.opacity(0.05))
                            }

                            Text("")
                                .frame(width: 88, alignment: .trailing)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 2)
                                .background(Color.gray.opacity(0.05))
                        }
                        .onTapGesture {
                            hideKeyboard()
                        }
                    }
                    // Tap anywhere inside the table (header, Orientation column, Largest Delta row, or empty space)
                    // but outside the actual TextField inputs to dismiss the keyboard.
                    .background(
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                hideKeyboard()
                            }
                    )

                    HStack {
                        Text("Include Diagonal orientations")
                        Spacer()
                        Image(systemName: includeDiagonals ? "checkmark.square.fill" : "square")
                            .foregroundColor(.blue)
                    }
                    .font(.caption)
                    .onTapGesture {
                        hideKeyboard()
                        includeDiagonals.toggle()
                    }
                    .padding(.top, 8)
                }

                // Results
                Section("Results") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Average Rate: \(String(format: "%.2f", averageRate)) s/d")
                        Text("Max Delta: \(String(format: "%.2f", maxDelta)) s/d")
                        Text("Horizontal Avg: \(String(format: "%.2f", horizontalAvg)) s/d")
                        Text("Vertical Avg: \(String(format: "%.2f", verticalAvg)) s/d")
                        Text("Horizontal vs Vertical Drop: \(String(format: "%.2f", verticalDrop)) s/d")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
                }

                // Dynamic Poising heavy spot
                Section("Dynamic Poising") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Heavy Spot on Balance Wheel")
                            .font(.headline)

                        Text("Vertical poise spread guidelines (low amplitude):")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("<10 s/d: excellent (modern/high-grade) • 10–20: good • ≤25 s/d: acceptable for vintage • >25: consider further poising")
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        if hasVerticalRates, let pos = fastestVerticalPosition {
                            Text("Fastest vertical position at low amplitude: **\(pos)**")
                                .font(.subheadline)
                            Text("Rule: The heavy spot is directly below the balance staff in the vertical position where the watch runs fastest (low amplitude ~140-160°).")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Remove a minimal amount of material from the rim at the heavy spot (or add weight to the opposite side).")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            let vertD = verticalPositions.compactMap { computedRates[$0] }
                            let pD = (vertD.max() ?? 0) - (vertD.min() ?? 0)
                            Text("Poise delta (vert. rate spread): \(String(format: "%.1f", pD)) s/d")
                                .font(.caption)
                                .foregroundStyle(pD < 10 ? .green : (pD < 25 ? .orange : .red))

                            BalanceWheelView(heavyPosition: pos)
                                .frame(height: 250)
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                        } else {
                            Text("Enter rates for vertical positions (Crown Down/Left/Up/Right) to determine the heavy spot.")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            BalanceWheelView(heavyPosition: nil)
                                .frame(height: 210)
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                        }
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
                }

                // Save button
                Section {
                    Button {
                        saveToCameraRoll()
                    } label: {
                        Label("Save Timegrapher results to camera roll", systemImage: "square.and.arrow.down")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isSaving)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }

                Text("© Dan Ricks 2026")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }

            }
            .navigationTitle("Timegrapher Logging")
            .onAppear {
                initializeReadings()
            }
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        hideKeyboard()
                    }
            )
            .alert("Saved!", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The results image has been saved to your Photos library.")
            }
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    hideKeyboard()
                }
        )
    }
}

struct BalanceWheelView: View {
    let heavyPosition: String?

    var body: some View {
        VStack(spacing: 6) {
            Canvas { context, size in
                let cx = size.width / 2
                let cy = size.height / 2 - 5
                let r = min(size.width, size.height) / 2 * 0.78

                // Determine crown stem angle based on heavyPosition
                // Heavy spot is always drawn at bottom (270°); stem shows the crown direction for that orientation
                var stemAngle: Double = 270
                if let pos = heavyPosition {
                    switch pos {
                    case "Crown Down": stemAngle = 270   // stem at bottom
                    case "Crown Left": stemAngle = 180   // stem at left
                    case "Crown Up": stemAngle = 90      // stem at top
                    case "Crown Right": stemAngle = 0    // stem at right
                    case "Crown Up Left": stemAngle = 135   // stem top-left
                    case "Crown Up Right": stemAngle = 45   // stem top-right
                    case "Crown Down Left": stemAngle = 225 // stem bottom-left
                    case "Crown Down Right": stemAngle = 315 // stem bottom-right
                    default: stemAngle = 270
                    }
                }

                // Outer rim (thick)
                let rim = Path { p in
                    p.addArc(center: CGPoint(x: cx, y: cy), radius: r, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                }
                context.stroke(rim, with: .color(.black), lineWidth: 14)

                // Inner rim
                let innerRim = Path { p in
                    p.addArc(center: CGPoint(x: cx, y: cy), radius: r * 0.72, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                }
                context.stroke(innerRim, with: .color(.gray), lineWidth: 3)

                // Spokes / arms
                for i in 0..<6 {
                    let angle = Double(i) * 60.0 - 90.0
                    let rad = angle * Double.pi / 180
                    let inner = r * 0.35
                    let x1 = cx + cos(rad) * inner
                    let y1 = cy + sin(rad) * inner
                    let x2 = cx + cos(rad) * r * 0.68
                    let y2 = cy + sin(rad) * r * 0.68
                    let spoke = Path { p in
                        p.move(to: CGPoint(x: x1, y: y1))
                        p.addLine(to: CGPoint(x: x2, y: y2))
                    }
                    context.stroke(spoke, with: .color(.gray), lineWidth: 2.5)
                }

                // Timing screws / weights around rim (8 positions)
                let numScrews = 8
                var heavyAngle: Double = 270  // default bottom
                if heavyPosition != nil {
                    // Always show heavy at bottom for clarity; caption explains the position
                    heavyAngle = 270
                }

                for i in 0..<numScrews {
                    let angle = Double(i) * (360.0 / Double(numScrews)) - 90.0
                    let rad = angle * Double.pi / 180
                    let sx = cx + cos(rad) * r * 0.88
                    let sy = cy + sin(rad) * r * 0.88
                    let screwSize: CGFloat = 10

                    let screwRect = CGRect(x: sx - screwSize/2, y: sy - screwSize/2, width: screwSize, height: screwSize)
                    let screwPath = Path(ellipseIn: screwRect)

                    context.fill(screwPath, with: .color(.gray))
                    context.stroke(screwPath, with: .color(.black), lineWidth: 1)
                    // tiny center dot
                    let dot = Path(ellipseIn: CGRect(x: sx-1.5, y: sy-1.5, width: 3, height: 3))
                    context.fill(dot, with: .color(.black))
                }

                // Crown stem (protruding bar + crown end) for orientation
                // Placed relative to heavy spot at bottom
                if heavyPosition != nil {
                    let stemRad = stemAngle * Double.pi / 180
                    let stemStartDist = r + 2
                    let stemLength: CGFloat = 26
                    let stemInnerX = cx + cos(stemRad) * stemStartDist
                    let stemInnerY = cy - sin(stemRad) * stemStartDist
                    let stemOuterX = cx + cos(stemRad) * (stemStartDist + stemLength)
                    let stemOuterY = cy - sin(stemRad) * (stemStartDist + stemLength)

                    // Thick stem bar
                    let stemPath = Path { p in
                        p.move(to: CGPoint(x: stemInnerX, y: stemInnerY))
                        p.addLine(to: CGPoint(x: stemOuterX, y: stemOuterY))
                    }
                    context.stroke(stemPath, with: .color(.black), lineWidth: 7)

                    // Crown knob at outer end (small rounded rect)
                    let crownW: CGFloat = 16
                    let crownH: CGFloat = 9
                    let crownRect = CGRect(x: stemOuterX - crownW/2, y: stemOuterY - crownH/2, width: crownW, height: crownH)
                    let crownPath = Path(roundedRect: crownRect, cornerSize: CGSize(width: 2, height: 2))
                    context.fill(crownPath, with: .color(.black))
                    context.stroke(crownPath, with: .color(.gray), lineWidth: 1)
                }

                // Central staff / arbor
                let hub = Path(ellipseIn: CGRect(x: cx-8, y: cy-8, width: 16, height: 16))
                context.fill(hub, with: .color(.black))
                context.stroke(hub, with: .color(.white), lineWidth: 1)

                // Red arrow / indicator for heavy spot (pointing inward to the heavy screw at bottom)
                if heavyPosition != nil {
                    let markerX = cx
                    let markerY = cy + r * 0.88 + 28  // further below to avoid stem overlap
                    // Arrow line
                    let arrowLine = Path { p in
                        p.move(to: CGPoint(x: cx, y: cy + r * 0.55))
                        p.addLine(to: CGPoint(x: markerX, y: markerY - 8))
                    }
                    context.stroke(arrowLine, with: .color(.red), lineWidth: 2.5)

                    // Arrow head
                    let head = Path { p in
                        p.move(to: CGPoint(x: markerX - 6, y: markerY - 12))
                        p.addLine(to: CGPoint(x: markerX, y: markerY - 3))
                        p.addLine(to: CGPoint(x: markerX + 6, y: markerY - 12))
                    }
                    context.fill(head, with: .color(.red))

                    // Label
                    let label = Text("REMOVE\nWEIGHT").font(.system(size: 9, weight: .bold))
                    context.draw(label, at: CGPoint(x: cx, y: markerY + 10), anchor: .top)
                }

                // Small center cross for staff
                let cross = Path { p in
                    p.move(to: CGPoint(x: cx - 5, y: cy))
                    p.addLine(to: CGPoint(x: cx + 5, y: cy))
                    p.move(to: CGPoint(x: cx, y: cy - 5))
                    p.addLine(to: CGPoint(x: cx, y: cy + 5))
                }
                context.stroke(cross, with: .color(.white), lineWidth: 1)
            }
            .frame(maxWidth: .infinity)

            if let pos = heavyPosition {
                Text("Heavy spot at bottom (bottom in \(pos) position). Crown stem shown on the corresponding side for orientation.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text("Balance wheel (enter vertical rates to mark heavy spot)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
