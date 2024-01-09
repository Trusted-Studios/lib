<script lang="ts">
    import { fetchNui } from "$utils/FetchNui";
    import { useNuiEvent } from "$utils/NuiEvents";
    import { Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell, TableSearch } from "flowbite-svelte";

    // Nui variabes
    let open: boolean = false;
    let text: any = [];
    let tableData: any = {}
    let items: any = [];
    let searchItem: string = "label"
    let other: any;

    // Table variables
    let searchTerm: string = "";
    let filteredItems: any = [];

    $: filteredItems = Object.values(items).filter((item: any) => {
        return item[searchItem] && item[searchItem].toLowerCase().includes(searchTerm.toLowerCase());
    });

    // NUI events & table functions
    useNuiEvent("open:table", function (data: any) {
        open = true 
        text = data?.text 
        tableData = data?.tableData || tableData
        items = data?.items || items
        searchItem = data?.searchItem || ""
        other = data?.other
    });

    useNuiEvent("close:table", function () {
        open = false;
    });

    function HandleRow(item: any, index: any) {
        fetchNui("table:handleRow", {
            item: item,
            index: index,
            other: other,
        });
    }

    function closeTable(e: any) {
        if (e.keyCode == 27) {
            open = false;
            fetchNui("table:close");
        }
    }
</script>

<svelte:window on:keydown={closeTable} />

{#if open}
    <div class="flex items-center justify-center">
        <Table divClass="mt-20 ml-8 mr-8 rounded-b-2xl">
            <TableSearch placeholder="Suchen" hoverable={true} bind:inputValue={searchTerm}>
                <caption class="p-5 text-lg font-semibold text-left dark:text-white dark:bg-gray-800 rounded-t-xl">
                    {text?.header || "invalid"}
                    <p class="mt-1 text-sm font-normal text-gray-500 dark:text-gray-400">{text?.description || "invalid"}.</p>
                </caption>
                <div class="max-h-[40rem] overflow-scroll">
                    <TableHead>
                        {#each tableData?.header || [{}] as tableHeadCellInput}
                            <TableHeadCell>{tableHeadCellInput || "invalid"}</TableHeadCell>
                        {/each}
                    </TableHead>
                    <TableBody tableBodyClass="divide-y">
                        {#each filteredItems.length > 0 ? filteredItems : [{}] as item, index}
                            <TableBodyRow class="cursor-pointer" on:click={() => HandleRow(item, index)}>
                                {#each tableData?.body || [{}] as tableBodyCellKey}
                                    <TableBodyCell tdClass="px-6 py-4 whitespace-nowrap font-medium lg:min-w-[22rem] min-w-[10rem]">{item[tableBodyCellKey] || "invalid"}</TableBodyCell>
                                {/each}
                            </TableBodyRow>
                        {/each}
                    </TableBody>
                </div>
            </TableSearch>
        </Table>
    </div>
{/if}
