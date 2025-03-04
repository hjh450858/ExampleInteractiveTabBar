//
//  InteractiveTabBar.swift
//  ExampleInteractiveTabBar
//
//  Created by 황재현 on 3/4/25.
//

import Foundation
import SwiftUI

/// Custom Tab Bar
struct InteractiveTabBar: View {
    ///현재 활성화된 탭 바인딩
    @Binding var activeTab: TabItem
    /// "matchGeometryEffect"을 사용하기 위한 네임스페이스
    @Namespace private var animation
    /// 각 탭 버튼의 위치 정보를 저장
    @State private var tabButtonLocations: [CGRect] = Array(repeating: .zero, count: TabItem.allCases.count)
    
    /// 사용자가 드래그중인 탭을 저장하는 상태
    @State private var activeDraggingTab: TabItem?
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                tabButton(tab)
            }
        }
        // 탭 바의 높이
        .frame(height: 70)
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .background {
            Rectangle()
            /*
             primary = 라이트모드일때 검정색, 다크모드일때 흰색
             */
                .fill(.background.shadow(.drop(color: .primary.opacity(0.2), radius: 4)))
                .ignoresSafeArea()
//                .padding(.top, 20)
        }
        /*
         coordinateSpace = 특정 뷰의 좌표 공간에 이름을 할당하여, 다른쪽에서 points와 size같은 값을 적용시킬때
         명시한 이름(ex: "TABBAR")으로 접근할 수 있게 도와줌
         드래그 좌표를 "TABBAR"라는 네임스페이스로 관리
         */
        .coordinateSpace(.named("TABBAR"))
    }
    
    /*
     @ViewBuilder - SwiftUI에서 뷰를 구성하는 특수한 속성래퍼
     여러 개의 뷰를 하나의 반환 값처럼 반환할 수 있음
     즉, 여러 개의 SwiftUI 뷰를 묶어 하나의 반환값처럼 사용할 수 있도록 함
     1개의 뷰만 있을경우 "@ViewBuilder"말고 "return" VStack { ... } 하면 가능
     */
    @ViewBuilder
    func tabButton(_ tab: TabItem) -> some View {
        /// 현재 활성화된 탭인지 확인함
        let isActive = (activeDraggingTab ?? activeTab) == tab
        
        VStack(spacing: 4) {
            Image(systemName: tab.symbolImage)
                .symbolVariant(.fill)
                // 활성화된 경우 아이콘 크기 50x50, 배경에 파란색 원이 생김
                .frame(width: isActive ? 50 : 25, height: isActive ? 50 : 25)
//                .frame(width: 25, height: 25, alignment: .bottom)
                .background {
                    // 활성화된 경웅 파란색 원
                    if isActive {
                        Circle()
                            .fill(.blue.gradient)
                            // 부드러운 애니메이션 효과 추가
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
                .contentShape(.rect)
                // 드래그 제스쳐
                .gesture(
                    DragGesture(coordinateSpace: .named("TABBAR"))
                        // 드래그 위치(value.location)을 이용해 어떤 탭 위에 있는지 확인
                        .onChanged { value in
                            print("gesture - value = \(value)")
                            let location = value.location
                            
                            if let index = tabButtonLocations.firstIndex(where: { $0.contains(location) }) {
                                withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                    activeDraggingTab = TabItem.allCases[index]
                                }
                            }
                            // 드래그가 끝나면 activeTab을 변경하여 탭이 바뀌도록 함
                        }.onEnded { _ in
                            if let activeDraggingTab {
                                activeTab = activeDraggingTab
                            }
                            
                            activeDraggingTab = nil
                        },
                    isEnabled: activeTab == tab
                )
                .frame(width: 25, height: 25, alignment: .bottom)
                .foregroundStyle(isActive ? .white : .primary)
            
            Text(tab.rawValue)
                .font(.caption2)
                .foregroundStyle(isActive ? .blue : .gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        /*
         탭 버튼의 위치 저장
         각 버튼의 위치 (tabButtonLocations) 배열에 저장
         이 정보가 있어야 드래그 시 어떤 탭 위에 있는지 감지 가능
         */
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .named("TABBAR"))
        } action: { newValue in
            tabButtonLocations[tab.index] = newValue
        }
        .contentShape(.rect)
        /*
         탭 클릭 이벤트
         사용자가 버튼을 클릭하면 부드러운 애니메이션과 함께 해당 탭이 활성화됨.
        */
        .onTapGesture {
            withAnimation(.snappy) {
                activeTab = tab
            }
        }
    }
}
