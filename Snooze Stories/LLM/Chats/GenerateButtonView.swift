import SwiftUI
import llmfarm_core_cpp
import UniformTypeIdentifiers
import Darwin

struct GenerateButtonView: View {
    @StateObject var aiChatModel = AIChatModel()
    var isFormValid: Bool
//    @StateObject var fineTuneModel = FineTuneModel()
    
    @State var searchText: String = ""
    @State var model_name = ""
    @State var title = ""
    @State var add_chat_dialog = false
    @State var edit_chat_dialog = false
    func close_chat() -> Void{
        aiChatModel.stop_predict()
    }
    @State private var chat_selection: Dictionary<String, String>?
    @State var chats_previews:[Dictionary<String, String>] = []
    @State var renew_chat_list: () -> Void = {}
    @State var current_detail_view_name:String? = "Chat"
    @State private var toggleSettings = false
    @State private var toggleAddChat = false
    
    let storyPrompt: String
    
    func refresh_chat_list(){
        self.chats_previews = get_chats_list()!
    }
    
    func delete(at offsets: IndexSet) {
        let chatsToDelete = offsets.map { self.chats_previews[$0] }
        _ = delete_chats(chatsToDelete)
        refresh_chat_list()        
    }
    
    func delete(at elem:Dictionary<String, String>){
        _ = delete_chats([elem])
        self.chats_previews.removeAll(where: { $0 == elem })
        refresh_chat_list()
    }

    func duplicate(at elem:Dictionary<String, String>){
        _ = duplicate_chat(elem)        
        refresh_chat_list()
    }
    
    //MARK: AddChatView snippets
    @State var model_setting_templates = get_model_setting_templates()
    @State private var model_settings_template:ChatSettingsTemplate = ChatSettingsTemplate()
    @State var applying_template:Bool = false
    
    @State private var model_inference = "llama"
    @State private var prompt_format: String = "{{prompt}}"
    @State private var model_context: Int32 = 1024
    @State private var model_n_batch: Int32 = 512
    @State private var model_temp: Float = 0.9
    @State private var model_top_k: Int32 = 40
    @State private var model_top_p: Float = 0.95
    @State private var model_repeat_penalty: Float = 1.1
    @State private var model_repeat_last_n: Int32 = 64
    @State private var reverse_prompt:String = ""
    @State private var use_metal: Bool = false
    @State private var mirostat: Int32 = 0
    @State private var mirostat_tau: Float = 5.0
    @State private var mirostat_eta: Float = 0.1
    @State private var grammar: String = "<None>"
    @State private var numberOfThreads: Int32 = 0
    @State private var add_bos_token: Bool = true
    @State private var add_eos_token: Bool = false
    @State private var parse_special_tokens: Bool = true
    @State private var mmap: Bool = true
    @State private var mlock: Bool = false
    @State private var tfs_z: Float = 1.0
    @State private var typical_p: Float = 1.0
    var hardware_arch = Get_Machine_Hardware_Name()
    
    func selectTemplateByName(_ name: String) {
        if let selectedTemplate = model_setting_templates.first(where: { $0.template_name == name }) {
            print("Found temp")
            model_settings_template = selectedTemplate
            apply_setting_template(template: selectedTemplate)
        }
        else {
            print("did not find")
        }
    }
    
    func apply_setting_template(template:ChatSettingsTemplate){
        model_inference = template.inference
        prompt_format = template.prompt_format
        model_context = template.context
        model_n_batch = template.n_batch
        model_temp = template.temp
        model_top_k = template.top_k
        model_top_p = template.top_p
        model_repeat_penalty = template.repeat_penalty
        model_repeat_last_n = template.repeat_last_n
        reverse_prompt = template.reverse_prompt
        use_metal = template.use_metal
        mirostat = template.mirostat
        mirostat_tau = template.mirostat_tau
        mirostat_eta = template.mirostat_eta
        grammar = template.grammar
        numberOfThreads = template.numberOfThreads
        add_bos_token = template.add_bos_token
        add_eos_token = template.add_eos_token
        parse_special_tokens = template.parse_special_tokens
        mmap = template.mmap
        mlock = template.mlock
        tfs_z = template.tfs_z
        typical_p = template.typical_p
        if hardware_arch=="x86_64"{
            use_metal = false
        }
        run_after_delay(delay:1200, function:{applying_template = false})
    }
    
    @State private var model_file_url: URL = Bundle.main.url(forResource: "Phi-3-mini-128k-instruct.IQ4_NL", withExtension: "gguf") ?? URL(fileURLWithPath: "/")
    @State private var model_file_path: String = (Bundle.main.path(forResource: "Phi-3-mini-128k-instruct.IQ4_NL", ofType: "gguf") ?? "Select model")
    var chat_name: String = ""
    
    func get_fixed_options_dict(is_template:Bool = false) -> Dictionary<String, Any> {
        var options:Dictionary<String, Any> =    ["model":model_file_path,
                                                  "model_settings_template":model_settings_template.template_name,
                                                  "title":"Phi-3 Fixed",
                                                  "icon":"ava0",
                                                  "model_inference":"llama",
                                                  "use_metal":use_metal,
                                                  "mlock":mlock,
                                                  "mmap":mmap,
                                                  "prompt_format":prompt_format,
                                                  "warm_prompt":"\n\n\n",
                                                  "reverse_prompt":reverse_prompt,
                                                  "numberOfThreads":Int32(numberOfThreads),
                                                  "context":Int32(model_context),
                                                  "n_batch":Int32(model_n_batch),
                                                  "temp":Float(model_temp),
                                                  "repeat_last_n":Int32(model_repeat_last_n),
                                                  "repeat_penalty":Float(model_repeat_penalty),
                                                  "top_k":Int32(model_top_k),
                                                  "top_p":Float(model_top_p),
                                                  "mirostat":mirostat,
                                                  "mirostat_eta":mirostat_eta,
                                                  "mirostat_tau":mirostat_tau,
                                                  "tfs_z":tfs_z,
                                                  "typical_p":typical_p,
                                                  "grammar":grammar,
                                                  "add_bos_token":add_bos_token,
                                                  "add_eos_token":add_eos_token,
                                                  "parse_special_tokens":parse_special_tokens
        ]
        if is_template{
            options["template_name"] = "New Template"
        }
        return options
    }
    //MARK: AddChatView snippets END
    
    //MARK: ChatView snippets
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    @State private var scrollTarget: Int?
    @State private var clearChatAlert = false
    
    @State private var auto_scroll = true
    @FocusState var focusedField: Field?
    
    func scrollToBottom(with_animation:Bool = false) {
        var scroll_bug = true
#if os(macOS)
        scroll_bug = false
#else
        if #available(iOS 16.4, *){
            scroll_bug = false
        }
#endif
        if scroll_bug {
            return
        }
        if !auto_scroll {
            return
        }
        let last_msg = aiChatModel.messages.last // try to fixscrolling and  specialized Array._checkSubscript(_:wasNativeTypeChecked:)
        if last_msg != nil && last_msg?.id != nil && scrollProxy != nil{
            if with_animation{
                withAnimation {
                    //                    scrollProxy?.scrollTo(last_msg?.id, anchor: .bottom)
                    scrollProxy?.scrollTo("latest")
                }
            }else{
                //                scrollProxy?.scrollTo(last_msg?.id, anchor: .bottom)
                scrollProxy?.scrollTo("latest")
            }
        }
        
    }
    
    func reload() async{
        if chat_selection == nil {
            return
        }
                
//        print(chat_selection as Any)
//        print("\nreload\n")
        aiChatModel.reload_chat(chat_selection!)
    }
    
    // Function to send a default message
    private func sendDefaultMessage() {
//        print("Reached Default message func")
        let defaultMessage = "Hello, how are you?"  // Default message
        aiChatModel.send(message: defaultMessage, img_path: nil)
    }
    
    private var starOverlay: some View {
        
        Button {
            Task{
                auto_scroll = true
                scrollToBottom()
            }
        }
        
    label: {
        Image(systemName: "arrow.down.circle")
            .resizable()
            .foregroundColor(.white)
            .frame(width: 25, height: 25)
            .padding([.bottom, .trailing], 15)
            .opacity(0.4)
    }
    .buttonStyle(BorderlessButtonStyle())
    }
    
    //MARK: ChatView snippets END
    
    //MARK: EXPERIMENTING with fixed Previews
    func setupAndCreateChat(from details: Dictionary<String, String>, fixed_file_name: String) {
        selectTemplateByName("Phi 3") // Assumes "Phi 3" is appropriate for your fixed preview
        apply_setting_template(template: self.model_settings_template)
        
        Task {
//             Assuming the model file needs to be handled similarly
            if model_file_url.path != "/", let sandboxPath = copyModelToSandbox(url: model_file_url, dest: "models") {
                model_file_path = sandboxPath
            }

            var options = get_fixed_options_dict(is_template: false)
            options.merge(details) { (current, _) in current } // Merge with fixed preview details but don't overwrite existing keys

            let (success, fileName) = create_chat_get_name(options, edit_chat_dialog: self.edit_chat_dialog, chat_name: fixed_file_name)
            if success, let fname = fileName {
                print("Chat created successfully with file name: \(fname)")
            } else {
                print("Failed to create chat")
            }
            renew_chat_list()
        }
    }
    //MARK: EXPERIMENTING with fixed Previews
    
    @State private var isGenerateView: Bool = false
    var chatCount: Int {
        chats_previews.count
    }
    @State private var isShowingFixedChatView: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 5){
                let fixedChatPreview: Dictionary<String, String> = [
                    "chat": "Phi-3 (Custom) - 1_1715767669.json",
                    "title": "Phi-3 FIXED",
                    "message": "llama ctx:1024",
                    "time": "10:30 AM",
                    "model": "Phi-3-mini-128k-instruct.IQ4_NL.gguf",
                    "icon": "ava0",
                    "mmodal": "0"
                ]
                
                VStack(alignment: .leading, spacing: 5) {
                    Button {
                        print("Generate button pressed")
                        let fileName = "Fixed - chat.json"
                        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let chatFilePath = documentDirectory.appendingPathComponent("chats/\(fileName)")

                        Task {
                            if FileManager.default.fileExists(atPath: chatFilePath.path) {
                                print("File already exists. Loading chat preview.")
                                await MainActor.run {
                                    refresh_chat_list() // Ensure the list is updated
                                    if let selectedChat = chats_previews.first(where: { $0["chat"] == fileName }) {
                                        chat_selection = selectedChat
                                        isShowingFixedChatView = true
//                                        print("Chat_Selection & Preview Loaded: \(selectedChat)")
                                    } else {
                                        print("No matching chat found in previews. Might need to refresh list or check filename consistency.")
                                    }
                                }
                            } else {
                                print("File does not exist. Creating with default settings...")
                                setupAndCreateChat(from: fixedChatPreview, fixed_file_name: fileName)
                                await MainActor.run {
                                    refresh_chat_list()
                                    if let selectedChat = chats_previews.first(where: { $0["chat"] == fileName }) {
                                        chat_selection = selectedChat
                                        isShowingFixedChatView = true
//                                        print("Selected chat details: \(String(describing: selectedChat))")
                                    } else {
                                        print("Chat was created but could not be found immediately in previews. Check async timing or refresh mechanisms.")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text("Generate")
                            Image(systemName: "sparkles")
                        }
                        .fontWeight(.medium)
                        .padding([.top, .bottom], 15)
                        .frame(maxWidth: 300)
                        .background(isFormValid ? .indigo : .gray)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                    }
                    .disabled(!isFormValid)
                    .padding(.vertical)
                    
                    .navigationDestination(isPresented: $isShowingFixedChatView) {
                        StoryGenerationView(
                            aiChatModel: aiChatModel, model_name: $model_name,
                            chat_selection: $chat_selection,
                            title: $title,
                            close_chat:close_chat,
                            add_chat_dialog:$add_chat_dialog,
                            edit_chat_dialog:$edit_chat_dialog, storyPrompt: storyPrompt)
                    }
                }
                .background(.opacity(0))
            }.task {
                renew_chat_list = refresh_chat_list
                refresh_chat_list()
            }
        }
    }
}
