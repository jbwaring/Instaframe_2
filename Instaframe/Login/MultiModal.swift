
////https://github.com/davdroman/MultiModal THANK YOU SO MUCH FOR THIS!
///This is free and unencumbered software released into the public domain.

//Anyone is free to copy, modify, publish, use, compile, sell, or
//distribute this software, either in source code form or as a compiled
//binary, for any purpose, commercial or non-commercial, and by any
//means.
//
//In jurisdictions that recognize copyright laws, the author or authors
//of this software dedicate any and all copyright interest in the
//software to the public domain. We make this dedication for the benefit
//of the public at large and to the detriment of our heirs and
//successors. We intend this dedication to be an overt act of
//relinquishment in perpetuity of all present and future rights to this
//software under copyright law.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//OTHER DEALINGS IN THE SOFTWARE.
//

import SwiftUI

extension View {
    /// Presents multiple modals (e.g. sheet, alert) at the same view level.
    ///
    /// Example:
    ///
    /// ```swift
    /// .multiModal {
    ///     $0.sheet(isPresented: $sheetAPresented) { Text("Sheet A") }
    ///     $0.sheet(isPresented: $sheetBPresented) { Text("Sheet B") }
    ///     $0.sheet(isPresented: $sheetCPresented) { Text("Sheet C") }
    /// }
    /// ```
    public func  multiModal(
        @MultiModalCollector _ modals: (EmptyView) -> [AnyView]
    ) -> some View {
        modals(EmptyView()).reduce(AnyView(self)) { view, modal in
            AnyView(view.background(modal))
        }
    }
}

@_functionBuilder
public struct MultiModalCollector {
    public static func buildBlock<V0: View>(
        _ v0: V0
    ) -> [AnyView] {
        [AnyView(v0)]
    }

    public static func buildBlock<V0: View, V1: View>(
        _ v0: V0,
        _ v1: V1
    ) -> [AnyView] {
        [AnyView(v0), AnyView(v1)]
    }

    public static func buildBlock<V0: View, V1: View, V2: View>(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2
    ) -> [AnyView] {
        [AnyView(v0), AnyView(v1), AnyView(v2)]
    }

    public static func buildBlock<V0: View, V1: View, V2: View, V3: View>(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2,
        _ v3: V3
    ) -> [AnyView] {
        [AnyView(v0), AnyView(v1), AnyView(v2), AnyView(v3)]
    }

    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View>(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4
    ) -> [AnyView] {
        [AnyView(v0), AnyView(v1), AnyView(v2), AnyView(v3), AnyView(v4)]
    }
}
