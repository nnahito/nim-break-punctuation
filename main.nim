import nre
import unicode

# ====================================================
# かぎガッコなどの囲み文字中は句点（。）が来ても改行しない
# ====================================================

# 囲み文字の開始
let noBreakSymbols = [
    "「", "(", "（",
]

# 囲み文字の終了
let endNoBreakSymbols = [
    "」", ")", "）"
]

# ====================================================
# 処理
# ====================================================

# ファイルの読み込み
let fileText = readFile("sample.txt")

# 改行とタブ文字、余計なスペースなどの削除
var noBreakText = fileText.replace(re"[\n|\r|\t|\s]", "")

# rune型に変換
let runeStrings = noBreakText.toRunes

var inlineSymbol = 0
var tmpString: string
var lines: seq[string]

# 1文字ずつ見ていく
for oneText in runeStrings:
    let str = $oneText

    # 句点が来たらそこまでを1行とする
    if str == "。" and inlineSymbol == 0:
        tmpString = tmpString & str
        lines.add(tmpString)
        inlineSymbol = 0
        tmpString = ""
        continue
    
    # 対象文字が囲み文字の開始文字でないかの確認
    for noBreakSymbol in noBreakSymbols:
        if str == noBreakSymbol:
            inlineSymbol = inlineSymbol + 1
            break
    
    # 対象文字が囲み文字の終了文字でないかの確認
    for endNoBreakSymbol in endNoBreakSymbols:
        if str == endNoBreakSymbol:
            inlineSymbol = inlineSymbol - 1
            break
    
    # 特に何もなければ、一行単位として一時変数に文字をためていく
    tmpString = tmpString & str

# 結果を書き出す
var fp = open("result.txt", FileMode.fmWrite)
for line in lines:
    fp.write(line)
    fp.write("\n")
