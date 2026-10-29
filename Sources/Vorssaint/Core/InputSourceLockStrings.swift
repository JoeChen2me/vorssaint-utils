// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

struct InputSourceLockStrings {
    let pageTitle: String
    let hubDescription: String
    let enable: String
    let enableCaption: String
    let activeNow: String
    let secureInputPaused: String
    let globalSection: String
    let globalSourceLabel: String
    let globalNone: String
    let globalCaption: String
    let perAppSection: String
    let perAppCaption: String
    let addApps: String
    let removeApp: String
    let noApps: String
    let appPickerTitle: String
    let appPickerSearch: String
    let appPickerAdd: String
    let appPickerCancel: String
    let appPickerEmpty: String
    let appPickerSelectedFormat: String
    let appPickerBrowse: String
    let sourceUnavailable: String
    let noSources: String
    let noSourcesCaption: String
    let openKeyboardSettings: String
    let guardSection: String
    let guardInterval: String
    let showSwitchNotice: String
    let guardCaption: String
}

extension FeatureStrings {
    static func inputSourceLock(_ language: AppLanguage) -> InputSourceLockStrings {
        switch language {
        case .enUS: return .enUS
        case .ptBR: return .ptBR
        case .tr: return .tr
        case .ru: return .ru
        case .es: return .es
        case .sk: return .sk
        case .de: return .de
        case .fr: return .fr
        case .it: return .it
        case .ja: return .ja
        case .ko: return .ko
        case .zhHans: return .zhHans
        case .zhTW: return .zhTW
        case .zhHK: return .zhHK
        case .uk: return .uk
        }
    }
}

extension InputSourceLockStrings {
    static let enUS = InputSourceLockStrings(
        pageTitle: "Input source lock",
        hubDescription: "Keeps the input source you choose, in every app or in the apps you list, and switches back when something changes it.",
        enable: "Lock the input source",
        enableCaption: "While this is on, the guard checks the frontmost app and switches back to its chosen source.",
        activeNow: "Guarding the input source now",
        secureInputPaused: "Paused while Secure Event Input is on",
        globalSection: "All apps",
        globalSourceLabel: "Input source",
        globalNone: "Don’t change",
        globalCaption: "Used for every app without its own rule. Choose Don’t change to leave other apps alone.",
        perAppSection: "Per-app overrides",
        perAppCaption: "An app listed here uses its own source instead of the one above.",
        addApps: "Add apps",
        removeApp: "Remove app",
        noApps: "No apps added yet.",
        appPickerTitle: "Add apps",
        appPickerSearch: "Search apps",
        appPickerAdd: "Add",
        appPickerCancel: "Cancel",
        appPickerEmpty: "No apps found.",
        appPickerSelectedFormat: "%1$d selected",
        appPickerBrowse: "Browse",
        sourceUnavailable: "Not enabled",
        noSources: "No input sources are enabled",
        noSourcesCaption: "Add an input source in System Settings, then come back here.",
        openKeyboardSettings: "Open Keyboard settings",
        guardSection: "Guard",
        guardInterval: "Check every",
        showSwitchNotice: "Show a Dynamic Island notice when the guard switches",
        guardCaption: "The guard switches the source back within this interval, including a manual change, a shortcut, or the Input menu."
    )

    static let ptBR = InputSourceLockStrings(
        pageTitle: "Bloqueio da fonte de entrada",
        hubDescription: "Mantém a fonte de entrada escolhida em todos os apps ou nos apps listados e a restaura quando ela muda.",
        enable: "Bloquear a fonte de entrada",
        enableCaption: "Enquanto isto está ativo, o guarda verifica o app em primeiro plano e restaura a fonte escolhida.",
        activeNow: "Fonte de entrada protegida",
        secureInputPaused: "Pausado enquanto a entrada segura está ativa",
        globalSection: "Todos os apps",
        globalSourceLabel: "Fonte de entrada",
        globalNone: "Não alterar",
        globalCaption: "Usada em todo app sem regra própria. Escolha Não alterar para deixar os outros apps em paz.",
        perAppSection: "Regras por app",
        perAppCaption: "Um app listado aqui usa a própria fonte em vez da geral.",
        addApps: "Adicionar apps",
        removeApp: "Remover app",
        noApps: "Nenhum app adicionado ainda.",
        appPickerTitle: "Adicionar apps",
        appPickerSearch: "Buscar apps",
        appPickerAdd: "Adicionar",
        appPickerCancel: "Cancelar",
        appPickerEmpty: "Nenhum app encontrado.",
        appPickerSelectedFormat: "%1$d selecionados",
        appPickerBrowse: "Procurar",
        sourceUnavailable: "Não ativada",
        noSources: "Nenhuma fonte de entrada ativada",
        noSourcesCaption: "Adicione uma fonte de entrada nos Ajustes do Sistema e volte aqui.",
        openKeyboardSettings: "Abrir ajustes de Teclado",
        guardSection: "Guarda",
        guardInterval: "Verificar a cada",
        showSwitchNotice: "Mostrar aviso no Dynamic Island quando o guarda trocar",
        guardCaption: "O guarda restaura a fonte dentro deste intervalo, inclusive após uma alteração manual, um atalho ou o menu de entrada."
    )

    static let tr = InputSourceLockStrings(
        pageTitle: "Giriş kaynağı kilidi",
        hubDescription: "Seçilen giriş kaynağını tüm uygulamalarda veya listedeki uygulamalarda sabit tutar ve değiştiğinde geri alır.",
        enable: "Giriş kaynağını kilitle",
        enableCaption: "Açıkken koruma, öndeki uygulamayı denetler ve seçilen kaynağa geri döner.",
        activeNow: "Giriş kaynağı korunuyor",
        secureInputPaused: "Güvenli giriş açıkken duraklatıldı",
        globalSection: "Tüm uygulamalar",
        globalSourceLabel: "Giriş kaynağı",
        globalNone: "Değiştirme",
        globalCaption: "Kendi kuralı olmayan her uygulama için kullanılır. Diğer uygulamalara dokunmamak için Değiştirme seçeneğini seçin.",
        perAppSection: "Uygulama başına kurallar",
        perAppCaption: "Burada listelenen bir uygulama genel kaynak yerine kendi kaynağını kullanır.",
        addApps: "Uygulama ekle",
        removeApp: "Uygulamayı kaldır",
        noApps: "Henüz uygulama eklenmedi.",
        appPickerTitle: "Uygulama ekle",
        appPickerSearch: "Uygulama ara",
        appPickerAdd: "Ekle",
        appPickerCancel: "Vazgeç",
        appPickerEmpty: "Uygulama bulunamadı.",
        appPickerSelectedFormat: "%1$d seçili",
        appPickerBrowse: "Gözat",
        sourceUnavailable: "Etkin değil",
        noSources: "Etkin giriş kaynağı yok",
        noSourcesCaption: "Sistem Ayarları’nda bir giriş kaynağı ekleyip buraya dönün.",
        openKeyboardSettings: "Klavye ayarlarını aç",
        guardSection: "Koruma",
        guardInterval: "Denetim aralığı",
        showSwitchNotice: "Koruma değiştirdiğinde Dynamic Island’da bildir",
        guardCaption: "Koruma, kaynağı bu aralık içinde geri alır; elle yapılan değişiklikler, kısayollar ve giriş menüsü dahil."
    )

    static let ru = InputSourceLockStrings(
        pageTitle: "Закрепление источника ввода",
        hubDescription: "Закрепляет выбранный источник ввода для всех приложений или для указанных и возвращает его при изменении.",
        enable: "Закреплять источник ввода",
        enableCaption: "Пока это включено, защита проверяет активное приложение и возвращает выбранный источник.",
        activeNow: "Источник ввода под защитой",
        secureInputPaused: "Пауза, пока включён безопасный ввод",
        globalSection: "Все приложения",
        globalSourceLabel: "Источник ввода",
        globalNone: "Не менять",
        globalCaption: "Используется для приложений без собственного правила. Выберите Не менять, чтобы не трогать остальные.",
        perAppSection: "Правила для приложений",
        perAppCaption: "Приложение из этого списка использует свой источник вместо общего.",
        addApps: "Добавить приложения",
        removeApp: "Удалить приложение",
        noApps: "Приложения ещё не добавлены.",
        appPickerTitle: "Добавить приложения",
        appPickerSearch: "Поиск приложений",
        appPickerAdd: "Добавить",
        appPickerCancel: "Отмена",
        appPickerEmpty: "Приложения не найдены.",
        appPickerSelectedFormat: "Выбрано: %1$d",
        appPickerBrowse: "Обзор",
        sourceUnavailable: "Отключён",
        noSources: "Нет включённых источников ввода",
        noSourcesCaption: "Добавьте источник ввода в Системных настройках и вернитесь сюда.",
        openKeyboardSettings: "Открыть настройки клавиатуры",
        guardSection: "Защита",
        guardInterval: "Проверять каждые",
        showSwitchNotice: "Показывать уведомление в Dynamic Island при переключении",
        guardCaption: "Защита возвращает источник в течение этого интервала, включая ручное изменение, сочетание клавиш или меню ввода."
    )

    static let es = InputSourceLockStrings(
        pageTitle: "Bloqueo de fuente de entrada",
        hubDescription: "Mantiene la fuente de entrada elegida en todas las apps o en las apps de la lista y la restaura cuando cambia.",
        enable: "Bloquear la fuente de entrada",
        enableCaption: "Mientras está activo, el guardián comprueba la app en primer plano y restaura su fuente elegida.",
        activeNow: "Fuente de entrada vigilada",
        secureInputPaused: "En pausa mientras la entrada segura está activa",
        globalSection: "Todas las apps",
        globalSourceLabel: "Fuente de entrada",
        globalNone: "No cambiar",
        globalCaption: "Se usa en toda app sin regla propia. Elige No cambiar para dejar tranquilas las demás.",
        perAppSection: "Reglas por app",
        perAppCaption: "Una app de esta lista usa su propia fuente en lugar de la general.",
        addApps: "Añadir apps",
        removeApp: "Quitar app",
        noApps: "Aún no hay apps añadidas.",
        appPickerTitle: "Añadir apps",
        appPickerSearch: "Buscar apps",
        appPickerAdd: "Añadir",
        appPickerCancel: "Cancelar",
        appPickerEmpty: "No se encontraron apps.",
        appPickerSelectedFormat: "%1$d seleccionadas",
        appPickerBrowse: "Examinar",
        sourceUnavailable: "No activada",
        noSources: "No hay fuentes de entrada activadas",
        noSourcesCaption: "Añade una fuente de entrada en Ajustes del Sistema y vuelve aquí.",
        openKeyboardSettings: "Abrir ajustes de Teclado",
        guardSection: "Guardián",
        guardInterval: "Comprobar cada",
        showSwitchNotice: "Mostrar aviso en Dynamic Island cuando el guardián cambie",
        guardCaption: "El guardián restaura la fuente dentro de este intervalo, incluso tras un cambio manual, un atajo o el menú de entrada."
    )

    static let sk = InputSourceLockStrings(
        pageTitle: "Zámok vstupného zdroja",
        hubDescription: "Drží zvolený vstupný zdroj vo všetkých aplikáciách alebo v uvedených aplikáciách a po zmene ho vráti späť.",
        enable: "Zamknúť vstupný zdroj",
        enableCaption: "Kým je zapnuté, strážca kontroluje aplikáciu v popredí a vráti jej zvolený zdroj.",
        activeNow: "Vstupný zdroj je strážený",
        secureInputPaused: "Pozastavené, kým je zapnutý zabezpečený vstup",
        globalSection: "Všetky aplikácie",
        globalSourceLabel: "Vstupný zdroj",
        globalNone: "Nemeniť",
        globalCaption: "Použije sa pre každú aplikáciu bez vlastného pravidla. Ak chcete ostatné aplikácie nechať tak, vyberte Nemeniť.",
        perAppSection: "Pravidlá pre aplikácie",
        perAppCaption: "Aplikácia uvedená tu používa vlastný zdroj namiesto všeobecného.",
        addApps: "Pridať aplikácie",
        removeApp: "Odstrániť aplikáciu",
        noApps: "Zatiaľ nie sú pridané žiadne aplikácie.",
        appPickerTitle: "Pridať aplikácie",
        appPickerSearch: "Hľadať aplikácie",
        appPickerAdd: "Pridať",
        appPickerCancel: "Zrušiť",
        appPickerEmpty: "Nenašli sa žiadne aplikácie.",
        appPickerSelectedFormat: "Vybrané: %1$d",
        appPickerBrowse: "Prehliadať",
        sourceUnavailable: "Nie je zapnutý",
        noSources: "Nie sú zapnuté žiadne vstupné zdroje",
        noSourcesCaption: "Pridajte vstupný zdroj v Systémových nastaveniach a vráťte sa sem.",
        openKeyboardSettings: "Otvoriť nastavenia klávesnice",
        guardSection: "Strážca",
        guardInterval: "Kontrolovať každých",
        showSwitchNotice: "Zobraziť upozornenie v Dynamic Island pri prepnutí",
        guardCaption: "Strážca vráti zdroj v rámci tohto intervalu, vrátane ručnej zmeny, skratky alebo ponuky vstupu."
    )

    static let de = InputSourceLockStrings(
        pageTitle: "Eingabequellen-Sperre",
        hubDescription: "Hält die gewählte Eingabequelle in allen Apps oder in den aufgeführten Apps fest und stellt sie nach einer Änderung wieder her.",
        enable: "Eingabequelle sperren",
        enableCaption: "Solange dies aktiv ist, prüft die Wache die vorderste App und stellt deren gewählte Quelle wieder her.",
        activeNow: "Eingabequelle wird überwacht",
        secureInputPaused: "Pausiert, solange die sichere Eingabe aktiv ist",
        globalSection: "Alle Apps",
        globalSourceLabel: "Eingabequelle",
        globalNone: "Nicht ändern",
        globalCaption: "Gilt für jede App ohne eigene Regel. Wähle Nicht ändern, um andere Apps in Ruhe zu lassen.",
        perAppSection: "Regeln pro App",
        perAppCaption: "Eine hier aufgeführte App verwendet ihre eigene Quelle statt der allgemeinen.",
        addApps: "Apps hinzufügen",
        removeApp: "App entfernen",
        noApps: "Noch keine Apps hinzugefügt.",
        appPickerTitle: "Apps hinzufügen",
        appPickerSearch: "Apps suchen",
        appPickerAdd: "Hinzufügen",
        appPickerCancel: "Abbrechen",
        appPickerEmpty: "Keine Apps gefunden.",
        appPickerSelectedFormat: "%1$d ausgewählt",
        appPickerBrowse: "Durchsuchen",
        sourceUnavailable: "Nicht aktiviert",
        noSources: "Keine Eingabequellen aktiviert",
        noSourcesCaption: "Füge in den Systemeinstellungen eine Eingabequelle hinzu und kehre dann hierher zurück.",
        openKeyboardSettings: "Tastatureinstellungen öffnen",
        guardSection: "Wache",
        guardInterval: "Prüfen alle",
        showSwitchNotice: "Hinweis in der Dynamic Island anzeigen, wenn die Wache umschaltet",
        guardCaption: "Die Wache stellt die Quelle innerhalb dieses Intervalls wieder her, auch nach einer manuellen Änderung, einem Kurzbefehl oder über das Eingabemenü."
    )

    static let fr = InputSourceLockStrings(
        pageTitle: "Verrouillage de la source de saisie",
        hubDescription: "Conserve la source de saisie choisie dans toutes les apps ou dans les apps listées et la rétablit lorsqu’elle change.",
        enable: "Verrouiller la source de saisie",
        enableCaption: "Lorsque cette option est active, la garde vérifie l’app au premier plan et rétablit sa source choisie.",
        activeNow: "Source de saisie sous surveillance",
        secureInputPaused: "En pause pendant la saisie sécurisée",
        globalSection: "Toutes les apps",
        globalSourceLabel: "Source de saisie",
        globalNone: "Ne pas changer",
        globalCaption: "Utilisée pour chaque app sans règle propre. Choisissez Ne pas changer pour laisser les autres apps tranquilles.",
        perAppSection: "Règles par app",
        perAppCaption: "Une app listée ici utilise sa propre source au lieu de la source générale.",
        addApps: "Ajouter des apps",
        removeApp: "Retirer l’app",
        noApps: "Aucune app ajoutée pour l’instant.",
        appPickerTitle: "Ajouter des apps",
        appPickerSearch: "Rechercher des apps",
        appPickerAdd: "Ajouter",
        appPickerCancel: "Annuler",
        appPickerEmpty: "Aucune app trouvée.",
        appPickerSelectedFormat: "%1$d sélectionnées",
        appPickerBrowse: "Parcourir",
        sourceUnavailable: "Non activée",
        noSources: "Aucune source de saisie activée",
        noSourcesCaption: "Ajoutez une source de saisie dans Réglages Système, puis revenez ici.",
        openKeyboardSettings: "Ouvrir les réglages Clavier",
        guardSection: "Garde",
        guardInterval: "Vérifier toutes les",
        showSwitchNotice: "Afficher une notification dans Dynamic Island lors du changement",
        guardCaption: "La garde rétablit la source dans cet intervalle, y compris après un changement manuel, un raccourci ou le menu de saisie."
    )

    static let it = InputSourceLockStrings(
        pageTitle: "Blocco sorgente di input",
        hubDescription: "Mantiene la sorgente di input scelta in tutte le app o in quelle elencate e la ripristina quando cambia.",
        enable: "Blocca la sorgente di input",
        enableCaption: "Quando è attivo, la protezione controlla l’app in primo piano e ripristina la sorgente scelta.",
        activeNow: "Sorgente di input sotto controllo",
        secureInputPaused: "In pausa mentre l’input sicuro è attivo",
        globalSection: "Tutte le app",
        globalSourceLabel: "Sorgente di input",
        globalNone: "Non cambiare",
        globalCaption: "Usata per ogni app senza una regola propria. Scegli Non cambiare per lasciare in pace le altre app.",
        perAppSection: "Regole per app",
        perAppCaption: "Un’app elencata qui usa la propria sorgente invece di quella generale.",
        addApps: "Aggiungi app",
        removeApp: "Rimuovi app",
        noApps: "Nessuna app aggiunta.",
        appPickerTitle: "Aggiungi app",
        appPickerSearch: "Cerca app",
        appPickerAdd: "Aggiungi",
        appPickerCancel: "Annulla",
        appPickerEmpty: "Nessuna app trovata.",
        appPickerSelectedFormat: "%1$d selezionate",
        appPickerBrowse: "Sfoglia",
        sourceUnavailable: "Non attiva",
        noSources: "Nessuna sorgente di input attiva",
        noSourcesCaption: "Aggiungi una sorgente di input in Impostazioni di Sistema, poi torna qui.",
        openKeyboardSettings: "Apri impostazioni Tastiera",
        guardSection: "Protezione",
        guardInterval: "Controlla ogni",
        showSwitchNotice: "Mostra un avviso in Dynamic Island quando la protezione cambia",
        guardCaption: "La protezione ripristina la sorgente entro questo intervallo, anche dopo un cambio manuale, una scorciatoia o il menu di input."
    )

    static let ja = InputSourceLockStrings(
        pageTitle: "入力ソースの固定",
        hubDescription: "すべてのアプリ、または指定したアプリで入力ソースを固定し、変更されたら自動で戻します。",
        enable: "入力ソースを固定",
        enableCaption: "オンにすると、ガードが最前面のアプリを確認し、指定した入力ソースに戻します。",
        activeNow: "入力ソースを監視中",
        secureInputPaused: "セキュア入力中は一時停止",
        globalSection: "すべてのアプリ",
        globalSourceLabel: "入力ソース",
        globalNone: "変更しない",
        globalCaption: "個別のルールがないアプリに使われます。他のアプリをそのままにするには変更しないを選びます。",
        perAppSection: "アプリごとの指定",
        perAppCaption: "ここに追加したアプリは、上のグローバル設定ではなく独自の入力ソースを使います。",
        addApps: "アプリを追加",
        removeApp: "アプリを削除",
        noApps: "アプリはまだ追加されていません。",
        appPickerTitle: "アプリを追加",
        appPickerSearch: "アプリを検索",
        appPickerAdd: "追加",
        appPickerCancel: "キャンセル",
        appPickerEmpty: "アプリが見つかりません。",
        appPickerSelectedFormat: "%1$d 件選択中",
        appPickerBrowse: "参照",
        sourceUnavailable: "無効",
        noSources: "有効な入力ソースがありません",
        noSourcesCaption: "システム設定で入力ソースを追加してから、ここに戻ってください。",
        openKeyboardSettings: "キーボード設定を開く",
        guardSection: "ガード",
        guardInterval: "確認間隔",
        showSwitchNotice: "ガードが切り替えたときにDynamic Islandで通知",
        guardCaption: "ガードはこの間隔内に元へ戻します。手動の変更、ショートカット、入力メニューによる変更も対象です。"
    )

    static let ko = InputSourceLockStrings(
        pageTitle: "입력 소스 잠금",
        hubDescription: "모든 앱 또는 지정한 앱에서 입력 소스를 고정하고, 변경되면 자동으로 되돌립니다.",
        enable: "입력 소스 잠금",
        enableCaption: "켜면 보호 기능이 전면 앱을 확인하고 지정한 입력 소스로 되돌립니다.",
        activeNow: "입력 소스를 지키는 중",
        secureInputPaused: "보안 입력이 켜져 있는 동안 일시 중지",
        globalSection: "모든 앱",
        globalSourceLabel: "입력 소스",
        globalNone: "변경 안 함",
        globalCaption: "별도 규칙이 없는 앱에 적용됩니다. 다른 앱을 그대로 두려면 변경 안 함을 선택하세요.",
        perAppSection: "앱별 지정",
        perAppCaption: "여기에 추가한 앱은 위의 전역 입력 소스 대신 자신의 입력 소스를 사용합니다.",
        addApps: "앱 추가",
        removeApp: "앱 제거",
        noApps: "아직 추가한 앱이 없습니다.",
        appPickerTitle: "앱 추가",
        appPickerSearch: "앱 검색",
        appPickerAdd: "추가",
        appPickerCancel: "취소",
        appPickerEmpty: "앱을 찾을 수 없습니다.",
        appPickerSelectedFormat: "%1$d개 선택됨",
        appPickerBrowse: "찾아보기",
        sourceUnavailable: "사용 안 함",
        noSources: "사용할 수 있는 입력 소스가 없습니다",
        noSourcesCaption: "시스템 설정에서 입력 소스를 추가한 뒤 여기로 돌아오세요.",
        openKeyboardSettings: "키보드 설정 열기",
        guardSection: "보호",
        guardInterval: "확인 간격",
        showSwitchNotice: "보호 기능이 전환할 때 Dynamic Island에 알림",
        guardCaption: "보호 기능은 이 간격 안에 입력 소스를 되돌립니다. 직접 변경, 단축키, 입력 메뉴도 포함됩니다."
    )

    static let uk = InputSourceLockStrings(
        pageTitle: "Закріплення джерела введення",
        hubDescription: "Закріплює вибране джерело введення для всіх програм або для вказаних і повертає його після зміни.",
        enable: "Закріплювати джерело введення",
        enableCaption: "Коли це ввімкнено, захист перевіряє активну програму й повертає вибране джерело.",
        activeNow: "Джерело введення під захистом",
        secureInputPaused: "Пауза, поки ввімкнено безпечне введення",
        globalSection: "Усі програми",
        globalSourceLabel: "Джерело введення",
        globalNone: "Не змінювати",
        globalCaption: "Використовується для програм без власного правила. Виберіть Не змінювати, щоб не чіпати інші.",
        perAppSection: "Правила для програм",
        perAppCaption: "Програма зі списку використовує власне джерело замість загального.",
        addApps: "Додати програми",
        removeApp: "Видалити програму",
        noApps: "Програми ще не додано.",
        appPickerTitle: "Додати програми",
        appPickerSearch: "Пошук програм",
        appPickerAdd: "Додати",
        appPickerCancel: "Скасувати",
        appPickerEmpty: "Програми не знайдено.",
        appPickerSelectedFormat: "Вибрано: %1$d",
        appPickerBrowse: "Огляд",
        sourceUnavailable: "Вимкнено",
        noSources: "Немає ввімкнених джерел введення",
        noSourcesCaption: "Додайте джерело введення в Системних налаштуваннях і поверніться сюди.",
        openKeyboardSettings: "Відкрити налаштування клавіатури",
        guardSection: "Захист",
        guardInterval: "Перевіряти кожні",
        showSwitchNotice: "Показувати сповіщення в Dynamic Island під час перемикання",
        guardCaption: "Захист повертає джерело протягом цього інтервалу, зокрема після ручної зміни, комбінації клавіш або меню введення."
    )

    static let zhHans = InputSourceLockStrings(
        pageTitle: "输入法锁定",
        hubDescription: "为所有应用或指定的应用固定输入法，并在输入法被更改时自动切换回来。",
        enable: "锁定输入法",
        enableCaption: "开启后，守卫会检查最前方的应用，并自动切回它指定的输入法。",
        activeNow: "正在守护输入法",
        secureInputPaused: "安全输入开启期间暂停",
        globalSection: "所有应用",
        globalSourceLabel: "输入法",
        globalNone: "不更改",
        globalCaption: "用于没有单独规则的应用。选择不更改可让其他应用保持不变。",
        perAppSection: "按应用指定",
        perAppCaption: "这里列出的应用会使用各自的输入法，而不是上面的全局输入法。",
        addApps: "添加应用",
        removeApp: "移除应用",
        noApps: "尚未添加应用。",
        appPickerTitle: "添加应用",
        appPickerSearch: "搜索应用",
        appPickerAdd: "添加",
        appPickerCancel: "取消",
        appPickerEmpty: "未找到应用。",
        appPickerSelectedFormat: "已选择 %1$d 个",
        appPickerBrowse: "浏览",
        sourceUnavailable: "未启用",
        noSources: "没有已启用的输入法",
        noSourcesCaption: "请先在系统设置中添加输入法，然后返回这里。",
        openKeyboardSettings: "打开键盘设置",
        guardSection: "守卫",
        guardInterval: "检查间隔",
        showSwitchNotice: "切换时在 Dynamic Island 中提示",
        guardCaption: "输入法被更改后，守卫会在此间隔内切换回来，手动切换、快捷键和输入法菜单也不例外。"
    )

    static let zhTW = InputSourceLockStrings(
        pageTitle: "輸入方式鎖定",
        hubDescription: "在所有 App 或指定的 App 中固定所選輸入方式，並在變更時自動切回。",
        enable: "鎖定輸入方式",
        enableCaption: "開啟後，守衛會檢查最前面的 App，並切回其指定的輸入方式。",
        activeNow: "正在守護輸入方式",
        secureInputPaused: "安全輸入開啟期間暫停",
        globalSection: "所有 App",
        globalSourceLabel: "輸入方式",
        globalNone: "不變更",
        globalCaption: "用於沒有個別規則的 App。選擇不變更可讓其他 App 保持原狀。",
        perAppSection: "個別 App 規則",
        perAppCaption: "此處列出的 App 會使用自己的輸入方式，而非上方的一般設定。",
        addApps: "加入 App",
        removeApp: "移除 App",
        noApps: "尚未加入 App。",
        appPickerTitle: "加入 App",
        appPickerSearch: "搜尋 App",
        appPickerAdd: "加入",
        appPickerCancel: "取消",
        appPickerEmpty: "找不到 App。",
        appPickerSelectedFormat: "已選取 %1$d 個",
        appPickerBrowse: "瀏覽",
        sourceUnavailable: "未啟用",
        noSources: "沒有已啟用的輸入方式",
        noSourcesCaption: "請先在系統設定中加入輸入方式，再回到這裡。",
        openKeyboardSettings: "打開鍵盤設定",
        guardSection: "守衛",
        guardInterval: "檢查間隔",
        showSwitchNotice: "切換時在 Dynamic Island 中提示",
        guardCaption: "輸入方式被變更後，守衛會在此間隔內切回，手動切換、快速鍵和輸入方式選單也不例外。"
    )

    static let zhHK = InputSourceLockStrings(
        pageTitle: "輸入法鎖定",
        hubDescription: "在所有 App 或指定 App 中固定所選輸入法，並在變更時自動切換回來。",
        enable: "鎖定輸入法",
        enableCaption: "開啟後，守衛會檢查最前面的 App，並切換回其指定輸入法。",
        activeNow: "正在守護輸入法",
        secureInputPaused: "安全輸入開啟期間暫停",
        globalSection: "所有 App",
        globalSourceLabel: "輸入法",
        globalNone: "不變更",
        globalCaption: "用於沒有個別規則的 App。選擇不變更可讓其他 App 保持不變。",
        perAppSection: "個別 App 設定",
        perAppCaption: "這裡列出的 App 會使用自己的輸入法，而不是上方的一般設定。",
        addApps: "加入 App",
        removeApp: "移除 App",
        noApps: "尚未加入 App。",
        appPickerTitle: "加入 App",
        appPickerSearch: "搜尋 App",
        appPickerAdd: "加入",
        appPickerCancel: "取消",
        appPickerEmpty: "找不到 App。",
        appPickerSelectedFormat: "已選取 %1$d 個",
        appPickerBrowse: "瀏覽",
        sourceUnavailable: "未啟用",
        noSources: "沒有已啟用的輸入法",
        noSourcesCaption: "請先在系統設定加入輸入法，然後返回這裡。",
        openKeyboardSettings: "開啟鍵盤設定",
        guardSection: "守衛",
        guardInterval: "檢查間隔",
        showSwitchNotice: "切換時在 Dynamic Island 中提示",
        guardCaption: "輸入法被更改後，守衛會在這個間隔內切換回來，手動切換、快捷鍵和輸入法選單也不例外。"
    )
}
