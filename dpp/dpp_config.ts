import {
    BaseConfig,
    ContextBuilder,
    Dpp,
    Plugin,
} from "https://deno.land/x/dpp_vim@v1.0.0/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v1.0.0/deps.ts";

type Toml = {
    hooks_file?: string;
    ftplugins?: Record<string, string>;
    plugins?: Plugin[];
};

type LazyMakeStateResult = {
    plugins: Plugin[];
    stateLines: string[];
};

export class Config extends BaseConfig {
    override async config(args: {
        denops: Denops;
        contextBuilder: ContextBuilder;
        basePath: string;
        dpp: Dpp;
    }): Promise<{
        plugins: Plugin[];
        stateLines: string[];
        ftplugins: Record<string, string>;
        hooksFiles: string[];
    }> {
        args.contextBuilder.setGlobal({
            protocols: ["git"],
        });

        const [context, options] = await args.contextBuilder.get(args.denops);
        const dotfilesDir = "~/.config/nvim/dpp/toml";

        // ユーザー指定のTOMLファイルリスト
        const tomlFiles = [
            "dpp.toml",
            "colorscheme.toml",
            "lualine.toml",

            //LazyPlugins
            "dpp_lazy.toml",
            "lsp.toml",
            "ddc.toml",
            "ddu.toml",

            //ftplugins
            "ftplugins/go.toml",
            "ftplugins/json.toml",
            "ftplugins/lua.toml",
            "ftplugins/markdown.toml",
            "ftplugins/sql.toml",
            "ftplugins/toml.toml",
        ];

        // 即時ロード (lazy: false) の対象ファイル
        const immediateLoadTargets = [
            "dpp.toml",
            "colorscheme.toml",
            "lualine.toml",
        ];

        const tomls: Toml[] = [];

        // すべてのTOMLファイルをループ処理
        for (const file of tomlFiles) {
            const tomlPath = await fn.expand(
                args.denops,
                dotfilesDir + "/" + file,
            );

            // dpp.toml と dpp_colorscheme.toml 以外は lazy: true を設定
            const isLazy = !immediateLoadTargets.includes(file);

            // toml extAction でTOMLを読み込み
            const toml = (await args.dpp.extAction(
                args.denops,
                context,
                options,
                "toml",
                "load",
                {
                    path: tomlPath,
                    options: {
                        lazy: isLazy,
                    },
                },
            )) as Toml | undefined;

            if (toml) {
                tomls.push(toml);
            }
        }

        // ---------------------------------------------------------------------
        // 2. プラグイン、ftplugins, hooksFiles を統合
        // ---------------------------------------------------------------------

        const recordPlugins: Record<string, Plugin> = {};
        const ftplugins: Record<string, string> = {};
        const hooksFiles: string[] = [];

        tomls.forEach((toml) => {
            for (const plugin of toml.plugins ?? []) {
                recordPlugins[plugin.name] = plugin;
            }

            if (toml.ftplugins) {
                for (const filetype of Object.keys(toml.ftplugins)) {
                    if (ftplugins[filetype]) {
                        ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
                    } else {
                        ftplugins[filetype] = toml.ftplugins[filetype];
                    }
                }
            }

            if (toml.hooks_file) {
                hooksFiles.push(toml.hooks_file);
            }
        });

        // ---------------------------------------------------------------------
        // 3. local 拡張の処理 (ローカルプラグイン)
        // ---------------------------------------------------------------------
        const localPlugins = (await args.dpp.extAction(
            args.denops,
            context,
            options,
            "local",
            "local",
            {
                directory: "~/Documents/LocalNeovimPlugins/",
                options: {
                    frozen: true,
                    merged: false,
                },
            },
        )) as Plugin[] | undefined;

        if (localPlugins) {
            // Merge localPlugins
            for (const plugin of localPlugins) {
                if (plugin.name in recordPlugins) {
                    recordPlugins[plugin.name] = Object.assign(
                        recordPlugins[plugin.name],
                        plugin,
                    );
                } else {
                    recordPlugins[plugin.name] = plugin;
                }
            }
        }

        // ---------------------------------------------------------------------
        // 4. lazy 拡張の実行と結果の返却
        // ---------------------------------------------------------------------
        const lazyResult = (await args.dpp.extAction(
            args.denops,
            context,
            options,
            "lazy",
            "makeState",
            {
                plugins: Object.values(recordPlugins),
            },
        )) as LazyMakeStateResult | undefined;

        //console.log(lazyResult);

        return {
            ftplugins,
            hooksFiles,
            plugins: lazyResult?.plugins ?? [],
            stateLines: lazyResult?.stateLines ?? [],
        };
    }
}
