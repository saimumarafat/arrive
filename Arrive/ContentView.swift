import SwiftUI
import PhotosUI

// MARK: - Main App Entry
@MainActor
struct ArriveView: View {
    @State private var selectedTab = 0
    @State private var isLoggedIn = false
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("isDockHidden") private var isDockHidden = false
    
    init() {
        // Hide system tab bar globally
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            (isDarkMode ? Color(hex: "050505") : Color(hex: "F8F8F8")).ignoresSafeArea()
            
            if !isLoggedIn {
                HeroView(onLogin: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isLoggedIn = true
                        selectedTab = 0
                    }
                })
                .transition(.opacity.animation(.easeInOut(duration: 0.4)))
            } else {
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        DashboardView(selectedTab: $selectedTab)
                    }
                        .tabItem {
                            Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        }
                        .tag(0)
                    
                    CardsView()
                        .tabItem {
                            Image(systemName: selectedTab == 1 ? "creditcard.fill" : "creditcard")
                        }
                        .tag(1)
                    
                    ScanView()
                        .tabItem {
                            Image(systemName: "plus.circle.fill")
                        }
                        .tag(3)
                    
                    InsightsView()
                        .tabItem {
                            Image(systemName: selectedTab == 2 ? "chart.pie.fill" : "chart.pie")
                        }
                        .tag(2)
                    
                    NavigationStack {
                        ProfileView(isLoggedIn: $isLoggedIn)
                    }
                    .tabItem {
                        Image(systemName: selectedTab == 4 ? "person.circle.fill" : "person.circle")
                    }
                    .tag(4)
                }
                .environment(\.colorScheme, isDarkMode ? .dark : .light)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

// MARK: - Screen 1: Hero View
struct HeroView: View {
    @State private var revealProgress: CGFloat = 0
    @AppStorage("isDarkMode") private var isDarkMode = true
    var onLogin: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Logo
            HStack {
                Text("Arrive.")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundColor(isDarkMode ? .white : .black)
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 20)
            
            // Card Stack Graphic
            ZStack {
                // Back Card (Aura Abstract)
                AsyncImage(url: URL(string: "https://hoirqrkdgbmvpwutwuwj.supabase.co/storage/v1/object/public/assets/assets/4734259a-bad7-422f-981e-ce01e79184f2_1600w.jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.indigo.opacity(0.3)
                }
                .frame(width: 270, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .rotationEffect(.degrees(12))
                .offset(x: 40, y: -20)
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                
                // Front Card (Dark Glass Gradient)
                VStack(alignment: .leading) {
                    HStack {
                        VStack(spacing: 2) {
                            Rectangle().fill(Color.white.opacity(0.4)).frame(width: 24, height: 1)
                            Rectangle().fill(Color.white.opacity(0.4)).frame(width: 24, height: 1)
                        }
                        .frame(width: 32, height: 24)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.white.opacity(0.2), lineWidth: 1))
                        
                        Spacer()
                        Image(systemName: "wifi")
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text("Debit Card")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.6))
                            Text("•••• 3094")
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .foregroundColor(.white)
                                .kerning(2)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: -8) {
                            Circle().fill(Color.indigo).frame(width: 16, height: 16).opacity(0.9)
                            Circle().fill(Color.purple).frame(width: 16, height: 16).opacity(0.9)
                        }
                    }
                }
                .padding(20)
                .frame(width: 290, height: 175)
                .background(
                    ZStack {
                        Color.black
                        LinearGradient(
                            colors: [Color.black.opacity(0.8), Color.black.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .rotationEffect(.degrees(-4))
                .offset(x: -10, y: 30)
                .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 15)
            }
            .padding(.top, 80)
            
            Spacer()
            
            // Hero Text
            VStack(alignment: .leading, spacing: 12) {
                // Animated Title
                VStack(alignment: .leading, spacing: 0) {
                    revealText("Master Your")
                    revealText("Financial Future")
                }
                .font(.system(size: 52, weight: .medium))
                .foregroundColor(isDarkMode ? .white : .black)
                
                Text("Automate savings, track intelligent insights, and build wealth effortlessly.")
                    .font(.system(size: 20))
                    .foregroundColor(isDarkMode ? .gray : .gray)
                    .lineSpacing(4)
                    .padding(.trailing, 40)
                
                HStack(spacing: 12) {
                    Button(action: onLogin) {
                        HStack {
                            Text("Open Account")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isDarkMode ? .black : .white)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 28)
                        .background(isDarkMode ? .white : .black)
                        .clipShape(Capsule())
                    }
                    
                    Button(action: onLogin) {
                        Text("Log In")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(isDarkMode ? .white : .black)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 36)
                            .background(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.1), lineWidth: 1))
                    }
                }
                .padding(.top, 20)
            }
            .padding(30)
            .background(
                LinearGradient(colors: [(isDarkMode ? Color(hex: "0a0a0a") : Color(hex: "F8F8F8")), (isDarkMode ? Color(hex: "0a0a0a").opacity(0.8) : Color(hex: "F8F8F8").opacity(0.8)), .clear], startPoint: .bottom, endPoint: .top)
            )
        }
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8).delay(0.2)) {
                revealProgress = 1
            }
        }
    }
    
    @ViewBuilder
    func revealText(_ text: String) -> some View {
        Text(text)
            .offset(y: (1 - revealProgress) * 50)
            .opacity(revealProgress)
            .mask(Rectangle().offset(y: (1 - revealProgress) * 50))
    }
}

// MARK: - UI Components
struct BackgroundGrid: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        ZStack {
            // Container with border
            Rectangle()
                .stroke((isDarkMode ? Color.white : Color.black).opacity(0.03), lineWidth: 1)
                .padding(.horizontal, 20)
            
            // Vertical Lines
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Spacer()
                    Divider().background((isDarkMode ? Color.white : Color.black).opacity(0.03)).frame(width: 1)
                    Spacer()
                    Divider().background((isDarkMode ? Color.white : Color.black).opacity(0.03)).frame(width: 1)
                    Spacer()
                }
                .frame(width: geo.size.width - 40)
                .offset(x: 20)
            }
            
            // Corner Mini Squares
            VStack {
                HStack {
                    Rectangle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.2), lineWidth: 1)
                        .frame(width: 6, height: 6)
                        .offset(x: -3, y: -3)
                    Spacer()
                    Rectangle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.2), lineWidth: 1)
                        .frame(width: 6, height: 6)
                        .offset(x: 3, y: -3)
                }
                Spacer()
                HStack {
                    Rectangle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.2), lineWidth: 1)
                        .frame(width: 6, height: 6)
                        .offset(x: -3, y: 3)
                    Spacer()
                    Rectangle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.2), lineWidth: 1)
                        .frame(width: 6, height: 6)
                        .offset(x: 3, y: 3)
                }
            }
        }
        .ignoresSafeArea()
    }
}

@MainActor
struct FloatingDock: View {
    @Binding var selectedTab: Int
    @AppStorage("isDarkMode") private var isDarkMode = true
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(icon: "house", label: "Home", tag: 0, selectedTab: $selectedTab, animation: animation, isDarkMode: isDarkMode)
            TabButton(icon: "creditcard", label: "Cards", tag: 1, selectedTab: $selectedTab, animation: animation, isDarkMode: isDarkMode)
            
            // Central Action Button (Larger)
            Button(action: { /* Action */ }) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 50, height: 50)
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .offset(y: -4)
            
            TabButton(icon: "chart.pie", label: "Insights", tag: 2, selectedTab: $selectedTab, animation: animation, isDarkMode: isDarkMode)
            TabButton(icon: "person.circle", label: "Profile", tag: 4, selectedTab: $selectedTab, animation: animation, isDarkMode: isDarkMode)
        }
        .padding(.horizontal, 12)
        .frame(width: 360, height: 74)
        .background(
            ZStack {
                BlurView(style: isDarkMode ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight)
                    .opacity(0.9)
                (isDarkMode ? Color.black : Color.white).opacity(0.2)
            }
        )
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(LinearGradient(colors: [(isDarkMode ? Color.white : Color.black).opacity(0.3), .clear], startPoint: .top, endPoint: .bottom), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}

struct TabButton: View {
    let icon: String
    let label: String
    let tag: Int
    @Binding var selectedTab: Int
    var animation: Namespace.ID
    let isDarkMode: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = tag
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: selectedTab == tag ? "\(icon).fill" : icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(selectedTab == tag ? .indigo : .gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    if selectedTab == tag {
                        Capsule()
                            .fill((isDarkMode ? Color.white : Color.black).opacity(0.08))
                            .matchedGeometryEffect(id: "pill", in: animation)
                            .frame(width: 65, height: 58)
                            .overlay(
                                Capsule()
                                    .stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 1)
                            )
                    }
                }
            )
        }
    }
}

// Custom Blur View for more "Liquid" control
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

enum CardStyle {
    case silver, darkBlue
}

enum CardNetwork {
    case mastercard, visa, amex
}

struct CardData: Identifiable {
    let id: Int
    let type: String
    let balance: String
    let digits: String
    let style: CardStyle
    let network: CardNetwork
}

// MARK: - Placeholder Views
struct DashboardView: View {
    @Binding var selectedTab: Int
    @AppStorage("isDarkMode") private var isDarkMode = true
    @State private var cards: [CardData] = [
        CardData(id: 0, type: "Virtual Card", balance: "$12,450.00", digits: "3094", style: .darkBlue, network: .mastercard),
        CardData(id: 1, type: "Physical Card", balance: "$4,200.00", digits: "8821", style: .silver, network: .visa),
        CardData(id: 2, type: "Business Card", balance: "$8,100.20", digits: "5501", style: .darkBlue, network: .amex)
    ]
    @State private var isExpanded = false
    @Namespace private var cardNamespace
    
    @AppStorage("profileName") private var profileName = "Sarah Mitchell"
    @AppStorage("profileImageData") private var profileImageData: Data = Data()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // Header Profile
                HStack {
                    HStack(spacing: 12) {
                        // Profile Image Content
                        if !profileImageData.isEmpty, let uiImage = UIImage(data: profileImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(Circle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 1))
                        } else {
                            AsyncImage(url: URL(string: "https://hoirqrkdgbmvpwutwuwj.supabase.co/storage/v1/object/public/assets/assets/4f5668c5-fc4a-44e0-bc5e-a664189d3c31_1600w.jpg")) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 1))
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Welcome back,")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Text(profileName.components(separatedBy: " ").first ?? profileName)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(isDarkMode ? .white : .black)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedTab = 4
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: NotificationsView()) {
                        Circle()
                            .stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 1)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "bell")
                                    .foregroundColor(isDarkMode ? .white : .black)
                                    .overlay(
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 8, height: 8)
                                            .offset(x: 10, y: -10)
                                    )
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Balance Card
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Balance")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    
                    Text("$24,092.50")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundColor(isDarkMode ? .white : .black)
                        .padding(.bottom, 12)
                    
                    // Quick Actions
                    HStack {
                        QuickAction(icon: "arrow.up.right", label: "Send", isDarkMode: isDarkMode)
                        Spacer()
                        QuickAction(icon: "arrow.down.left", label: "Request", isDarkMode: isDarkMode)
                        Spacer()
                        QuickAction(icon: "plus", label: "Add", isDarkMode: isDarkMode)
                    }
                }
                .padding(20)
                .background((isDarkMode ? Color.white : Color.black).opacity(0.03))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            (isDarkMode ? Color.white : Color.black).opacity(0.1),
                            lineWidth: 1
                        )
                )
                .padding(.horizontal, 20)
                
                // Cards Section
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Your Cards")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                            Text("Add New")
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.indigo)
                    }
                    .padding(.horizontal, 20)
                    
                    if !isExpanded {
                        // Stack Mode
                        ZStack(alignment: .leading) {
                            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                                let offset = CGFloat(index) * 20
                                PremiumCard(
                                    type: card.type,
                                    balance: card.balance,
                                    digits: card.digits,
                                    isDarkMode: isDarkMode,
                                    style: card.style,
                                    isSmall: true,
                                    network: card.network
                                )
                                .matchedGeometryEffect(id: "card\(card.id)", in: cardNamespace)
                                .offset(x: offset)
                                .opacity(1.0 - Double(index) * 0.15)
                                .zIndex(Double(10 - index))
                                .shadow(color: .black.opacity(index == 0 ? 0.15 : 0), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 160)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                isExpanded = true
                            }
                        }
                    } else {
                        // Expanded Mode (Horizontal Scroll)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                                    PremiumCard(
                                        type: card.type,
                                        balance: card.balance,
                                        digits: card.digits,
                                        isDarkMode: isDarkMode,
                                        style: card.style,
                                        isSmall: true,
                                        network: card.network,
                                        showShadow: false // Remove shadow to fix the gray line artifact
                                    )
                                    .matchedGeometryEffect(id: "card\(card.id)", in: cardNamespace)
                                    .zIndex(Double(10 - index)) // Preserve layering during expansion
                                    .onTapGesture { withAnimation { selectedTab = 1 } }
                                }
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 32))
                                    Text("Add New Card")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(isDarkMode ? .white : .black)
                                .frame(width: 240, height: 145)
                                .background(RoundedRectangle(cornerRadius: 20).fill((isDarkMode ? Color.white : Color.black).opacity(0.08)))
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(isDarkMode ? Color.white.opacity(0.3) : Color.black.opacity(0.2), style: StrokeStyle(lineWidth: 1.5, dash: [6])))
                                .matchedGeometryEffect(id: "cardAdd", in: cardNamespace)
                                .zIndex(0)
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(height: 160)
                    }
                }
                
                // Watchlist
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Watchlist")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                        Spacer()
                        Text("See all")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    WatchlistItem(icon: "chart.bar", color: .indigo, title: "S&P 500", subtitle: "Index Fund", price: "$5,123.41", trend: "+1.24%", isDarkMode: isDarkMode)
                    WatchlistItem(icon: "cpu", color: .purple, title: "Tech ETF", subtitle: "Technology", price: "$432.10", trend: "+0.85%", isDarkMode: isDarkMode)
                    WatchlistItem(icon: "bitcoinsign.circle", color: .orange, title: "Bitcoin", subtitle: "Crypto", price: "$64,201.00", trend: "-0.42%", isDarkMode: isDarkMode)
                    WatchlistItem(icon: "leaf", color: .green, title: "Clean Energy", subtitle: "ESG Fund", price: "$124.50", trend: "+2.11%", isDarkMode: isDarkMode)
                    WatchlistItem(icon: "building.2", color: .blue, title: "Real Estate", subtitle: "REIT", price: "$2,840.15", trend: "+0.15%", isDarkMode: isDarkMode)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100) // Padding for dock
            }
        }
        .background((isDarkMode ? Color(hex: "050505") : Color(hex: "F8F8F8")).ignoresSafeArea())
        .refreshable {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
}

struct QuickAction: View {
    let icon: String
    let label: String
    let isDarkMode: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Circle()
                .stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 1.5)
                .frame(width: 54, height: 54)
                .background((isDarkMode ? Color.white : Color.black).opacity(0.05))
                .clipShape(Circle())
                .overlay(Image(systemName: icon).font(.title3).foregroundColor(isDarkMode ? .white : .black))
            
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}

struct WatchlistItem: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    let price: String
    let trend: String
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill((isDarkMode ? Color.white : Color.black).opacity(0.05))
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: icon).font(.system(size: 16)).foregroundColor(isDarkMode ? .white : .black))
                .overlay(Circle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(isDarkMode ? .white : .black)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(price)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(isDarkMode ? .white : .black)
                Text(trend)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(trend.contains("+") ? .green : .red)
            }
        }
    }
}

struct InsightsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 32) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Insights")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                        Text("October 2024")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Circle()
                        .stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 1)
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "calendar").font(.title2).foregroundColor(isDarkMode ? .white : .black))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Donut Chart
                ZStack {
                    DonutChart()
                        .frame(width: 220, height: 220)
                        .shadow(color: Color.indigo.opacity(isDarkMode ? 0.15 : 0.05), radius: 30)
                    
                    VStack(spacing: 6) {
                        Text("Spent")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        Text("$3,240.15")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                    }
                }
                
                // Legend
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    LegendItem(color: .indigo, label: "Housing", isDarkMode: isDarkMode)
                    LegendItem(color: .purple, label: "Food", isDarkMode: isDarkMode)
                    LegendItem(color: .blue, label: "Transport", isDarkMode: isDarkMode)
                    LegendItem(color: .cyan, label: "Entertainment", isDarkMode: isDarkMode)
                    LegendItem(color: .gray, label: "Other", isDarkMode: isDarkMode)
                }
                .padding(.horizontal, 20)
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Recent Activity")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(isDarkMode ? .white : .black)
                        Spacer()
                        Text("View all")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    TransactionItem(icon: "cart", title: "Whole Foods Market", subtitle: "Groceries", amount: "-$84.20", date: "Oct 24", isDarkMode: isDarkMode)
                    TransactionItem(icon: "icloud", title: "Cloud Services Inc.", subtitle: "Software", amount: "-$29.00", date: "Oct 22", isDarkMode: isDarkMode)
                    TransactionItem(icon: "cup.and.saucer", title: "Artisan Roasters", subtitle: "Coffee", amount: "-$6.50", date: "Oct 21", isDarkMode: isDarkMode)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .background((isDarkMode ? Color(hex: "050505") : Color(hex: "F8F8F8")).ignoresSafeArea())
    }
}

struct DonutChart: View {
    var body: some View {
        ZStack {
            // Segments (simplified as static for now)
            Circle()
                .trim(from: 0, to: 0.35)
                .stroke(Color.indigo, lineWidth: 15)
            Circle()
                .trim(from: 0.35, to: 0.6)
                .stroke(Color.purple, lineWidth: 15)
            Circle()
                .trim(from: 0.6, to: 0.8)
                .stroke(Color.blue, lineWidth: 15)
            Circle()
                .trim(from: 0.8, to: 0.95)
                .stroke(Color.cyan, lineWidth: 15)
            Circle()
                .trim(from: 0.95, to: 1.0)
                .stroke(Color.gray, lineWidth: 15)
        }
        .rotationEffect(.degrees(-90))
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor((isDarkMode ? Color.white : Color.black).opacity(0.8))
        }
    }
}

struct TransactionItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let amount: String
    let date: String
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill((isDarkMode ? Color.white : Color.black).opacity(0.05))
                .frame(width: 50, height: 50)
                .overlay(Image(systemName: icon).font(.title3).foregroundColor(isDarkMode ? .white : .black))
                .overlay(Circle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isDarkMode ? .white : .black)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(amount)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isDarkMode ? .white : .black)
                Text(date)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("profileName") private var profileName = "Sarah Mitchell"
    @AppStorage("profileImageData") private var profileImageData: Data = Data()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                VStack(spacing: 14) {
                    if !profileImageData.isEmpty, let uiImage = UIImage(data: profileImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                            .overlay(Circle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 2))
                    } else {
                        AsyncImage(url: URL(string: "https://hoirqrkdgbmvpwutwuwj.supabase.co/storage/v1/object/public/assets/assets/4f5668c5-fc4a-44e0-bc5e-a664189d3c31_1600w.jpg")) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                        .overlay(Circle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 2))
                    }
                    
                    VStack(spacing: 2) {
                        Text(profileName)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                    }
                }
                .padding(.top, 30)
                
                // Menu Groups
                VStack(spacing: 16) {
                    ProfileMenuSection(title: "Account Details", isDarkMode: isDarkMode) {
                        NavigationLink(destination: PersonalInformationView()) {
                            ProfileMenuItem(icon: "person.fill", title: "Personal Information", isDarkMode: isDarkMode)
                        }
                        Button(action: {}) { ProfileMenuItem(icon: "shield.fill", title: "Security & Login", isDarkMode: isDarkMode) }
                        Button(action: {}) { ProfileMenuItem(icon: "creditcard.fill", title: "Linked Accounts", isDarkMode: isDarkMode) }
                    }

                    ProfileMenuSection(title: "App Settings", isDarkMode: isDarkMode) {
                        HStack {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .font(.system(size: 18))
                                .foregroundColor(isDarkMode ? .white.opacity(0.7) : .black.opacity(0.7))
                                .frame(width: 24)
                            
                            Text("Dark Mode")
                                .font(.system(size: 16))
                                .foregroundColor(isDarkMode ? .white : .black)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isDarkMode.animation(.spring()))
                                .toggleStyle(SwitchToggleStyle(tint: .indigo))
                                .labelsHidden()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isDarkMode.toggle()
                            }
                        }
                    }
                    
                    ProfileMenuSection(title: "Banking Services", isDarkMode: isDarkMode) {
                        Button(action: {}) { ProfileMenuItem(icon: "arrow.left.arrow.right", title: "Transfer Limits", isDarkMode: isDarkMode) }
                        ProfileMenuItem(icon: "doc.text.fill", title: "Statements & E-Docs", isDarkMode: isDarkMode)
                        NavigationLink(destination: NotificationsView()) {
                            ProfileMenuItem(icon: "bell.fill", title: "Notifications", isDarkMode: isDarkMode)
                        }
                    }
                    
                    ProfileMenuSection(title: "", isDarkMode: isDarkMode) {
                        Button(action: {
                            withAnimation { isLoggedIn = false }
                        }) {
                            HStack {
                                Image(systemName: "power")
                                    .foregroundColor(.red)
                                Text("Log Out")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                            .background(Color.red.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 140)
            }
        }
        .background((isDarkMode ? Color(hex: "050505") : Color(hex: "F8F8F8")).ignoresSafeArea())
    }
}

struct ProfileMenuSection<Content: View>: View {
    let title: String
    let isDarkMode: Bool
    let content: Content
    
    init(title: String, isDarkMode: Bool, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isDarkMode = isDarkMode
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !title.isEmpty {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }
            VStack(spacing: 1) {
                content
            }
            .background(isDarkMode ? Color(hex: "111111") : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke((isDarkMode ? Color.white : Color.black).opacity(0.05), lineWidth: 1))
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor((isDarkMode ? Color.white : Color.black).opacity(0.7))
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(isDarkMode ? .white : .black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding()
        .contentShape(Rectangle())
    }
}

// MARK: - Helpers
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct GlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

extension View {
    func glass() -> some View {
        self.modifier(GlassModifier())
    }
}

// MARK: - Cards Section
struct CardsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @State private var isExpanded = false
    @Namespace private var cardNamespace
    
    // Shared card data for consistency
    private let cards: [CardData] = [
        CardData(id: 0, type: "Virtual Card", balance: "$12,450.00", digits: "3094", style: .darkBlue, network: .mastercard),
        CardData(id: 1, type: "Physical Card", balance: "$4,200.00", digits: "8821", style: .silver, network: .visa),
        CardData(id: 2, type: "Business Card", balance: "$8,100.20", digits: "5501", style: .darkBlue, network: .amex)
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("My Cards")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(isDarkMode ? .white : .black)
                        Text("Manage your physical and virtual cards")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.indigo)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Cards Stack/Carousel
                if !isExpanded {
                    ZStack(alignment: .leading) {
                        ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                            let offset = CGFloat(index) * 20
                            PremiumCard(
                                type: card.type,
                                balance: card.balance,
                                digits: card.digits,
                                isDarkMode: isDarkMode,
                                style: card.style,
                                isSmall: false,
                                network: card.network
                            )
                            .matchedGeometryEffect(id: "mainCard\(card.id)", in: cardNamespace)
                            .offset(x: offset)
                            .opacity(1.0 - Double(index) * 0.15)
                            .zIndex(Double(10 - index))
                            .shadow(color: .black.opacity(index == 0 ? 0.2 : 0), radius: 15, x: 0, y: 10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 180)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            isExpanded = true
                        }
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                                PremiumCard(
                                    type: card.type,
                                    balance: card.balance,
                                    digits: card.digits,
                                    isDarkMode: isDarkMode,
                                    style: card.style,
                                    isSmall: false,
                                    network: card.network,
                                    showShadow: false // Remove shadow to fix the gray line artifact
                                )
                                .matchedGeometryEffect(id: "mainCard\(card.id)", in: cardNamespace)
                                .zIndex(Double(10 - index))
                            }
                            
                            // Add Card placeholder
                            VStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 32))
                                Text("Add New Card")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(isDarkMode ? .white : .black)
                            .frame(width: 280, height: 175)
                            .background(RoundedRectangle(cornerRadius: 24).fill((isDarkMode ? Color.white : Color.black).opacity(0.08)))
                            .overlay(RoundedRectangle(cornerRadius: 24).stroke(isDarkMode ? Color.white.opacity(0.3) : Color.black.opacity(0.2), style: StrokeStyle(lineWidth: 1.5, dash: [6])))
                            .matchedGeometryEffect(id: "mainCardAdd", in: cardNamespace)
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 180)
                }
                
                // Card Actions
                VStack(alignment: .leading, spacing: 20) {
                    Text("Management")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isDarkMode ? .white : .black)
                    
                    VStack(spacing: 1) {
                        CardActionRow(icon: "lock.fill", title: "Freeze Card", subtitle: "Temporarily disable this card", toggle: true, isDarkMode: isDarkMode)
                        Divider().background(Color.gray.opacity(0.1)).padding(.leading, 50)
                        CardActionRow(icon: "key.fill", title: "Reset PIN", subtitle: "Change your security code", isDarkMode: isDarkMode)
                        Divider().background(Color.gray.opacity(0.1)).padding(.leading, 50)
                        CardActionRow(icon: "creditcard.and.123", title: "Replace Card", subtitle: "Order a new card if lost", isDarkMode: isDarkMode)
                    }
                    .background(isDarkMode ? Color.white.opacity(0.03) : Color.black.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal, 20)
                
                // Limits Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Monthly Limits")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isDarkMode ? .white : .black)
                    
                    LimitRow(title: "Spending Limit", current: 3240, total: 5000, color: .indigo, isDarkMode: isDarkMode)
                    LimitRow(title: "ATM Withdrawal", current: 800, total: 2000, color: .purple, isDarkMode: isDarkMode)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .background((isDarkMode ? Color(hex: "050505") : Color(hex: "F8F8F8")).ignoresSafeArea())
    }
}

struct PremiumCard: View {
    let type: String
    let balance: String
    let digits: String
    let isDarkMode: Bool
    let style: CardStyle
    var isSmall: Bool = false
    var network: CardNetwork = .mastercard
    var showShadow: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top: Balance and Type
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(type)
                        .font(.system(size: isSmall ? 8 : 10, weight: .medium))
                        .opacity(0.6)
                }
                
                Spacer()
                
                // Default NFC Icon
                Image(systemName: "wave.3.right")
                    .font(.system(size: isSmall ? 18 : 24))
                    .opacity(0.6)
            }
            .padding(.top, isSmall ? 16 : 24)
            .padding(.horizontal, isSmall ? 16 : 24)
            
            Spacer()
            
            // Middle: Card Number (Minimalist)
            Text("••••  ••••  ••••  \(digits)")
                .font(.system(size: isSmall ? 14 : 18, weight: .medium, design: .monospaced))
                .opacity(0.8)
                .padding(.horizontal, isSmall ? 16 : 24)
            
            Spacer()
            
            // Bottom: Name and Network
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sarah M.")
                        .font(.system(size: isSmall ? 10 : 13, weight: .medium))
                    Text("08 / 29")
                        .font(.system(size: isSmall ? 8 : 10))
                        .opacity(0.5)
                }
                
                Spacer()
                
                CardNetworkLogo(network: network, isSmall: isSmall, style: style)
            }
            .padding(.bottom, isSmall ? 16 : 24)
            .padding(.horizontal, isSmall ? 16 : 24)
        }
        .foregroundColor(style == .silver ? .black : .white)
        .frame(width: isSmall ? 240 : 280, height: isSmall ? 145 : 175)
        .background(
            ZStack {
                if style == .silver {
                    Color.white
                    LinearGradient(colors: [Color.white, Color(hex: "E5E5E5")], startPoint: .topLeading, endPoint: .bottomTrailing)
                } else {
                    Color(hex: "0A0A0A")
                    LinearGradient(colors: [Color(hex: "1C1C1E"), Color.black], startPoint: .topLeading, endPoint: .bottomTrailing)
                }
                
                // Subtle Native Blur Pattern
                Circle()
                    .fill(style == .silver ? Color.blue.opacity(0.05) : Color.indigo.opacity(0.1))
                    .frame(width: 200)
                    .offset(x: 100, y: -50)
                    .blur(radius: 40)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(style == .silver ? Color.black.opacity(isDarkMode ? 0.05 : 0.02) : Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(showShadow ? (isDarkMode ? 0.15 : 0.08) : 0), radius: isSmall ? 10 : 15, x: 0, y: isSmall ? 5 : 8)
    }
}

struct CardNetworkLogo: View {
    let network: CardNetwork
    let isSmall: Bool
    let style: CardStyle
    
    var body: some View {
        switch network {
        case .mastercard:
            MastercardLogo(isSmall: isSmall)
        case .visa:
            VisaLogo(isSmall: isSmall, style: style)
        case .amex:
            AmexLogo(isSmall: isSmall)
        }
    }
}

struct VisaLogo: View {
    var isSmall: Bool
    var style: CardStyle
    var body: some View {
        HStack(spacing: 2) {
            Text("VISA")
                .font(.system(size: isSmall ? 16 : 20, weight: .bold, design: .rounded))
                .italic()
                .tracking(-0.5)
        }
        .foregroundColor(style == .silver ? Color(hex: "1A1F71") : .white)
    }
}

struct MastercardLogo: View {
    var isSmall: Bool
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "EB001B"))
                .frame(width: isSmall ? 18 : 24, height: isSmall ? 18 : 24)
                .offset(x: isSmall ? -6 : -8)
            
            Circle()
                .fill(Color(hex: "F79E1B"))
                .frame(width: isSmall ? 18 : 24, height: isSmall ? 18 : 24)
                .offset(x: isSmall ? 6 : 8)
                .opacity(0.85)
            
            // Overlap area
            Circle()
                .fill(Color(hex: "FF5F00"))
                .frame(width: isSmall ? 18 : 24, height: isSmall ? 18 : 24)
                .mask(
                    Circle()
                        .offset(x: isSmall ? -6 : -8)
                )
                .offset(x: isSmall ? 6 : 8)
        }
        .frame(width: isSmall ? 32 : 40)
    }
}


struct AmexLogo: View {
    var isSmall: Bool
    var body: some View {
        AsyncImage(url: URL(string: "https://hoirqrkdgbmvpwutwuwj.supabase.co/storage/v1/object/public/assets/assets/6e2b9c7c-47b8-45a7-9512-42171173d193_1600w.png")) { phase in
            if let image = phase.image {
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isSmall ? 30 : 40)
                    .brightness(0.5) // Make it pop more on dark cards
                    .contrast(1.2)
            } else if phase.error != nil {
                // Fallback to a high-fidelity centurion-style placeholder
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .frame(width: isSmall ? 28 : 36)
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: isSmall ? 20 : 26))
                        .foregroundColor(.white.opacity(0.8))
                }
            } else {
                ProgressView()
                    .scaleEffect(isSmall ? 0.6 : 0.8)
            }
        }
    }
}


struct CardActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var toggle: Bool = false
    var isOn: Binding<Bool>? = nil
    let isDarkMode: Bool
    @State private var localIsOn = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill((isDarkMode ? Color.white : Color.black).opacity(0.05))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundColor(isDarkMode ? .white : .black)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(isDarkMode ? .white : .black)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if toggle {
                Toggle("", isOn: isOn ?? $localIsOn)
                    .labelsHidden()
                    .tint(.indigo)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .padding(16)
        .contentShape(Rectangle())
        .onTapGesture {
            if toggle {
                if let isOn = isOn {
                    withAnimation(.spring()) {
                        isOn.wrappedValue.toggle()
                    }
                } else {
                    withAnimation(.spring()) {
                        localIsOn.toggle()
                    }
                }
            }
        }
    }
}

struct LimitRow: View {
    let title: String
    let current: Double
    let total: Double
    let color: Color
    let isDarkMode: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isDarkMode ? .white : .black)
                Spacer()
                Text("$\(Int(current)) / $\(Int(total))")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill((isDarkMode ? Color.white : Color.black).opacity(0.05))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(LinearGradient(colors: [color, color.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * (current / total), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(20)
        .background(isDarkMode ? Color.white.opacity(0.03) : Color.black.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
struct ScanView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @State private var isScanning = true
    @State private var flashOn = false
    
    var body: some View {
        ZStack {
            // Camera Preview Mock
            Color.black.ignoresSafeArea()
            
            // Camera "Focus" or subtle pattern
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 400, height: 400)
                .blur(radius: 60)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {}) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Scan to Pay")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { flashOn.toggle() }) {
                        Image(systemName: flashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.white.opacity(flashOn ? 0.3 : 0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // Scanning Frame
                ZStack {
                    // Transparent Hole Effect
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                        .frame(width: 260, height: 260)
                    
                    // Corners
                    ScanningCorners()
                        .stroke(Color.indigo, lineWidth: 4)
                        .frame(width: 260, height: 260)
                    
                    // Scanning Line
                    Rectangle()
                        .fill(LinearGradient(colors: [.clear, .indigo, .clear], startPoint: .top, endPoint: .bottom))
                        .frame(width: 240, height: 2)
                        .offset(y: isScanning ? 120 : -120)
                        .onAppear {
                            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                                isScanning.toggle()
                            }
                        }
                }
                
                Text("Align QR code within the frame")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, 40)
                
                Spacer()
                
                // Bottom Actions
                HStack(spacing: 40) {
                    ScanActionButton(icon: "photo.on.rectangle", label: "Gallery")
                    ScanActionButton(icon: "qrcode", label: "My QR")
                    ScanActionButton(icon: "keyboard", label: "Enter ID")
                }
                .padding(.bottom, 60)
            }
        }
    }
}

struct ScanningCorners: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length: CGFloat = 40
        let radius: CGFloat = 32
        
        // Top Left
        path.move(to: CGPoint(x: 0, y: length))
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: length, y: 0))
        
        // Top Right
        path.move(to: CGPoint(x: rect.width - length, y: 0))
        path.addLine(to: CGPoint(x: rect.width - radius, y: 0))
        path.addArc(center: CGPoint(x: rect.width - radius, y: radius), radius: radius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width, y: length))
        
        // Bottom Right
        path.move(to: CGPoint(x: rect.width, y: rect.height - length))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - radius))
        path.addArc(center: CGPoint(x: rect.width - radius, y: rect.height - radius), radius: radius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width - length, y: rect.height))
        
        // Bottom Left
        path.move(to: CGPoint(x: length, y: rect.height))
        path.addLine(to: CGPoint(x: radius, y: rect.height))
        path.addArc(center: CGPoint(x: radius, y: rect.height - radius), radius: radius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: rect.height - length))
        
        return path
    }
}

struct ScanActionButton: View {
    let icon: String
    let label: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.white.opacity(0.1))
                .clipShape(Circle())
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
        }
    }
}
struct PersonalInformationView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedItem: PhotosPickerItem?
    @AppStorage("profileImageData") private var profileImageData: Data = Data()
    
    @AppStorage("profileName") private var name = "Sarah Mitchell"
    @AppStorage("profileEmail") private var email = "sarah.m@arrive.io"
    @AppStorage("profilePhone") private var phone = "+1 (555) 012-3456"
    @AppStorage("profileDob") private var dob = "January 12, 1994"
    @AppStorage("profileAddress") private var address = "1245 Financial Way, New York, NY"
    
    @State private var birthDate = Date()
    @State private var isCalendarExpanded = false
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    @AppStorage("isDockHidden") private var isDockHidden = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Profile Image Edit
                VStack(spacing: 16) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        ZStack(alignment: .bottomTrailing) {
                            if !profileImageData.isEmpty, let uiImage = UIImage(data: profileImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 2))
                            } else {
                                AsyncImage(url: URL(string: "https://hoirqrkdgbmvpwutwuwj.supabase.co/storage/v1/object/public/assets/assets/4f5668c5-fc4a-44e0-bc5e-a664189d3c31_1600w.jpg")) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke((isDarkMode ? Color.white : Color.black).opacity(0.1), lineWidth: 2))
                            }
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.indigo)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(isDarkMode ? Color.black : Color.white, lineWidth: 2))
                        }
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                profileImageData = data
                            }
                        }
                    }
                    
                    Text("Change Profile Photo")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.indigo)
                }
                .padding(.top, 20)
                
                // Form Fields
                VStack(spacing: 24) {
                    InfoEditGroup(title: "Identity", isDarkMode: isDarkMode) {
                        InfoTextField(label: "Full Name", text: $name, isDarkMode: isDarkMode)
                        Divider().background(Color.gray.opacity(0.1)).padding(.leading, 12)
                        
                        DisclosureGroup(isExpanded: $isCalendarExpanded) {
                            VStack(spacing: 12) {
                                DatePicker("", selection: $birthDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .tint(.indigo)
                                    .onChange(of: birthDate) { newDate in
                                        dob = dateFormatter.string(from: newDate)
                                    }
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            isCalendarExpanded = false
                                        }
                                    }) {
                                        Text("Okay")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 12)
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Date of Birth")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.gray)
                                Text(dob)
                                    .font(.system(size: 16))
                                    .foregroundColor(isDarkMode ? .white : .black)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .accentColor(.gray)
                    }
                    
                    InfoEditGroup(title: "Contact", isDarkMode: isDarkMode) {
                        InfoTextField(label: "Email Address", text: $email, isDarkMode: isDarkMode)
                        Divider().background(Color.gray.opacity(0.1)).padding(.leading, 12)
                        InfoTextField(label: "Phone Number", text: $phone, isDarkMode: isDarkMode)
                    }
                    
                    InfoEditGroup(title: "Location", isDarkMode: isDarkMode) {
                        InfoTextField(label: "Residential Address", text: $address, isDarkMode: isDarkMode)
                    }
                }
                .padding(.horizontal, 20)
                
            }
        }
        .navigationTitle("Personal Information")
        .navigationBarTitleDisplayMode(.inline)
        .background((isDarkMode ? Color(hex: "050505") : Color(hex: "F8F8F8")).ignoresSafeArea())
        .onAppear {
            if let date = dateFormatter.date(from: dob) {
                birthDate = date
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Text("Save")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.red)
                }
            }
        }
        .background((isDarkMode ? Color(hex: "050505") : Color(hex: "F8F8F8")).ignoresSafeArea())
    }
}

struct InfoEditGroup<Content: View>: View {
    let title: String
    let isDarkMode: Bool
    let content: Content
    
    init(title: String, isDarkMode: Bool, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isDarkMode = isDarkMode
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(isDarkMode ? Color.white.opacity(0.05) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke((isDarkMode ? Color.white : Color.black).opacity(0.05), lineWidth: 1))
        }
    }
}

struct InfoTextField: View {
    let label: String
    @Binding var text: String
    let isDarkMode: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
            
            TextField("", text: $text)
                .font(.system(size: 16))
                .foregroundColor(isDarkMode ? .white : .black)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Notifications View
struct NotificationsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @Environment(\.dismiss) private var dismiss
    
    let notifications = [
        NotificationData(id: 1, title: "Payment Received", message: "You received $250.00 from Alex Johnson.", time: "2m ago", icon: "arrow.down.left.circle.fill", color: .green, isUnread: true),
        NotificationData(id: 2, title: "Security Alert", message: "New login detected from a Safari browser in London.", time: "1h ago", icon: "shield.righthalf.filled", color: .orange, isUnread: true),
        NotificationData(id: 3, title: "Weekly Report", message: "Your spending was 15% lower than last week! Great job.", time: "5h ago", icon: "chart.bar.fill", color: .indigo, isUnread: false),
        NotificationData(id: 4, title: "Card Activated", message: "Your new Business Platinum card is ready to use.", time: "1d ago", icon: "creditcard.fill", color: .blue, isUnread: false),
        NotificationData(id: 5, title: "Subscription Paid", message: "Spotify Premium was successfully renewed for $10.99.", time: "2d ago", icon: "music.note", color: .purple, isUnread: false)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(notifications) { notification in
                    NavigationLink(destination: NotificationDetailView(notification: notification)) {
                        NotificationRow(notification: notification, isDarkMode: isDarkMode)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(20)
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .background((isDarkMode ? Color(hex: "050505") : Color(hex: "F8F8F8")).ignoresSafeArea())
    }
}

struct NotificationData: Identifiable {
    let id: Int
    let title: String
    let message: String
    let time: String
    let icon: String
    let color: Color
    let isUnread: Bool
}

struct NotificationRow: View {
    let notification: NotificationData
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(notification.color.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: notification.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(notification.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isDarkMode ? .white : .black)
                    
                    Spacer()
                    
                    Text(notification.time)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Text(notification.message)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            if notification.isUnread {
                Circle()
                    .fill(Color.indigo)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(16)
        .background(isDarkMode ? Color.white.opacity(0.05) : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke((isDarkMode ? Color.white : Color.black).opacity(0.05), lineWidth: 1)
        )
    }
}

// MARK: - Notification Detail View
struct NotificationDetailView: View {
    let notification: NotificationData
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        VStack(spacing: 32) {
            // Icon Header
            ZStack {
                Circle()
                    .fill(notification.color.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: notification.icon)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(notification.color)
            }
            .padding(.top, 40)
            
            VStack(spacing: 12) {
                Text(notification.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isDarkMode ? .white : .black)
                
                Text(notification.time)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Text(notification.message)
                .font(.system(size: 18))
                .foregroundColor(isDarkMode ? .white.opacity(0.8) : .black.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Action Button
            Button(action: {}) {
                Text(notification.title.contains("Payment") ? "View Transaction" : 
                     notification.title.contains("Security") ? "Secure Account" : "Dismiss")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(notification.color)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 40)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background((isDarkMode ? Color(hex: "050505") : Color(hex: "F8F8F8")).ignoresSafeArea())
    }
}
