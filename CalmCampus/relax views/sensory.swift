import SwiftUI

struct sensory: View {    
    let backgroundImage: Image = Image("movement")
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Image
                backgroundImage
                    .resizable()
                    .scaledToFill()
                Rectangle()
                    .fill(Color.black)
                    .scaledToFill()
               
                
            }
            }
        }
    }
    

struct sensory_Previews: PreviewProvider {
    static var previews: some View {
        sensory()
    }
}
