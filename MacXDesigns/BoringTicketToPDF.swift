//
//  BoringTicketToPDF.swift
//  MacXDesigns
//
//  Created by Shriram Vasudevan on 4/15/25.
//

import SwiftUI

struct BoringTicketToPDF: View {
    @State private var isDropTargetActive = false
    @State private var isLoading = false
    @State private var showTicket = false
    
    var body: some View {
        ZStack {
            MeditationBackground()
                .edgesIgnoringSafeArea(.all)
            
            if showTicket {
                TicketView()
                    .transition(.opacity)
            } else if isLoading {
                LoadingView()
                    .transition(.opacity)
            } else {
                DropZone(isDropTargetActive: $isDropTargetActive, handleFile: handleDroppedFile)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showTicket || isLoading)
    }

    func handleDroppedFile(url: URL) {
        withAnimation {
            isLoading = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 12.0) {
            withAnimation {
                isLoading = false
                showTicket = true
            }
        }
    }
}

struct DropZone: View {
    @Binding var isDropTargetActive: Bool
    var handleFile: (URL) -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "ticket.fill")
                .font(.system(size: 48))
                .foregroundColor(Color(hex: "5E72EB"))

            Text("Drop a Ticket to Begin")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "5E72EB").opacity(isDropTargetActive ? 1 : 0.3),
                            Color(hex: "FF9190").opacity(isDropTargetActive ? 1 : 0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: isDropTargetActive ? 2 : 1
                )
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                )
                .frame(width: 280, height: 140)
                .overlay(
                    VStack {
                        Image(systemName: "arrow.down.doc")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.7))
                        Text("Drag & Drop Here")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                )
        }
        .padding()
        .onDrop(of: ["public.file-url"], isTargeted: $isDropTargetActive) { items, _ in
            guard let item = items.first else { return false }
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, _) in
                guard let urlData = urlData as? Data,
                      let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL? else { return }
                DispatchQueue.main.async {
                    handleFile(url)
                }
            }
            return true
        }
    }
}

struct TicketView: View {
    @State private var showConfetti = false
    @State private var ticketAppeared = false

    var body: some View {
        ZStack {
    
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("LIVE IN CONCERT")
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundColor(.white.opacity(0.6))
                        Text("TAYLOR SWIFT")
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(.white)
                        Text("THE ERAS TOUR")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.blue)
                    }

                    Divider().background(Color.white.opacity(0.3))

                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 20) {
                            TicketInfo(label: "DATE", value: "APR 15, 2025")
                            TicketInfo(label: "TIME", value: "8:00 PM")
                        }
                        TicketInfo(label: "VENUE", value: "METLIFE STADIUM")
                        HStack(spacing: 20) {
                            TicketInfo(label: "SECTION", value: "FLOOR 3")
                            TicketInfo(label: "ROW", value: "H")
                            TicketInfo(label: "SEAT", value: "42")
                        }
                    }

                    Spacer()
                    Text("TICKET #: TS13579ER2025")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(30)
                .frame(width: 380)

                ZStack {
                    Rectangle().fill(Color.white.opacity(0.2)).frame(width: 1)
                    VStack {
                        ForEach(0..<8) { _ in
                            Circle()
                                .fill(Color.black.opacity(0.5))
                                .frame(width: 20, height: 20)
                                .padding(.vertical, 15)
                        }
                    }
                }

                VStack(spacing: 20) {
                    Image("qrcode")
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 180, height: 180)
                        .background(Color.white)
                        .cornerRadius(6)

                    Text("SCAN TO ENTER")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)

                    Text("Valid for one entry only")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(width: 220)
                .padding(.vertical, 30)
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.1, green: 0.3, blue: 0.8),
                            Color(red: 0.15, green: 0.1, blue: 0.5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(color: Color.blue.opacity(0.2), radius: 30, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.5),
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.0),
                            Color.white.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
            )
            .frame(height: 320)
            .opacity(ticketAppeared ? 1 : 0)
            .scaleEffect(ticketAppeared ? 1.0 : 0.95)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    ticketAppeared = true
                    showConfetti = true
                }
            }
        }
    }
}


struct TicketInfo: View {
    var label: String
    var value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct LoadingView: View {
    @State private var progress: Double = 0
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 6)
                    .frame(width: 80, height: 80)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "5E72EB"), Color(hex: "FF9190")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 80, height: 80)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 12.0)) {
                            progress = 1.0
                        }
                    }
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: "5E72EB"))
            }
            
            VStack(spacing: 10) {
                Text("Creating Your Digital Ticket")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                Text("Adding style and interactive elements")
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.7))
            }
        }
        .padding(40)
    }
}

struct MeditationBackground: View {
    @State private var phase1: CGFloat = 0
    @State private var phase2: CGFloat = 0
    @State private var phase3: CGFloat = 0
    
    let baseColor = Color(red: 0.1, green: 0.1, blue: 0.2)
    let accentColor1 = Color(red: 0.3, green: 0.4, blue: 0.6)
    let accentColor2 = Color(red: 0.2, green: 0.3, blue: 0.5)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [baseColor, .black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                Group {
                    HorizontalWaveLayer(phase: phase1, amplitude: 8, wavelength: 200, thickness: 40)
                        .fill(accentColor1.opacity(0.15))
                        .blur(radius: 20)
                    
                    HorizontalWaveLayer(phase: phase2, amplitude: 12, wavelength: 300, thickness: 35)
                        .fill(accentColor2.opacity(0.12))
                        .blur(radius: 15)
                        .offset(y: 100)

                    HorizontalWaveLayer(phase: phase3, amplitude: 10, wavelength: 250, thickness: 30)
                        .fill(accentColor1.opacity(0.1))
                        .blur(radius: 18)
                        .offset(y: -100)
                }

                ForEach(0..<40, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.05...0.15)))
                        .frame(width: CGFloat.random(in: 2...4), height: CGFloat.random(in: 2...4))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .blur(radius: 1)
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) { phase1 = 2 * .pi }
                withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) { phase2 = 2 * .pi }
                withAnimation(.linear(duration: 25).repeatForever(autoreverses: false)) { phase3 = 2 * .pi }
            }
        }
    }
}

struct HorizontalWaveLayer: Shape {
    var phase: CGFloat
    var amplitude: CGFloat
    var wavelength: CGFloat
    var thickness: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let midHeight = rect.height / 2
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))

        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / wavelength
            let y = sin(relativeX * 2 * .pi + phase) * amplitude + midHeight - thickness / 2
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: rect.width, y: midHeight + thickness / 2))

        for x in stride(from: rect.width, through: 0, by: -1) {
            let relativeX = x / wavelength
            let y = sin(relativeX * 2 * .pi + phase) * amplitude + midHeight + thickness / 2
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.closeSubpath()
        return path
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64

        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BoringTicketToPDF()
            .frame(width: 800, height: 600)
    }
}
