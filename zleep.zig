const std = @import("std");

// プログレスバー設定構造体
const ProgressBar = struct {
    sleep_percentage: f64,
    progress_bar: [20]u8,
};

pub fn main() anyerror!void {
    // コマンドライン引数のメモリ割当
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    // メモリ解放
    defer std.process.argsFree(allocator, args);

    // 引数チェック
    if (args.len == 2) {
        var i: u64 = 1;
        // 整数型にパース
        if (std.fmt.parseInt(u64, args[1], 10)) |seconds| {
            while (i <= seconds):(i += 1) {
                var s = try get_progress_bar(i, seconds);
                // プログレスバー表示
                try std.io.getStdOut().writer().print("\x1B[1K\x1B[G", .{});
                try std.io.getStdOut().writer().print("{d}/{d}s:[{s}]{d:.0}%", .{
                    i,
                    seconds,
                    s.progress_bar,
                    s.sleep_percentage * 100
                });
                // スリープ実行
                std.time.sleep(1000000000);
            }
        // パースエラー時
        } else |_| {
            try std.io.getStdOut().writer().print("引数には正の整数を入力してください。", .{});
        }
    } else {
        try std.io.getStdOut().writer().print("sleep 実施秒数を引数で入力してください。\nex: zleep 10", .{});
    }
    try std.io.getStdOut().writer().print("\n", .{});
}

fn get_progress_bar(i: u64, seconds: u64) !ProgressBar {
    var k: u64 = 0;
    var progress_bar = [_]u8{' '} ** 20;

    // 現在の sleep 秒数の割合を算出
    const sleep_percentage = @intToFloat(f64, i) / @intToFloat(f64, seconds);
    // プログレスバーの表示数を算出
    const progress = @floatToInt(usize, sleep_percentage * 20);

    // プログレスバー設定
    while (k < progress):(k += 1) {
        progress_bar[k] = '=';
    }

    // 構造体に戻り値を設定
    const progress_struct = ProgressBar {
        .sleep_percentage = sleep_percentage,
        .progress_bar = progress_bar
    };

    return progress_struct;
}

test "get progress bar" {
    const s = try get_progress_bar(10, 20);

    var i: u64 = 0;
    var count: u64 = 0;
    while (i < s.progress_bar.len):(i += 1) {
        if (s.progress_bar[i] == '=') {
            count += 1;
        } else {
            continue;
        }
    }
    try std.testing.expect(s.sleep_percentage == 0.5);
    try std.testing.expect(count == 10);
}