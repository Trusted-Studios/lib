<script lang="ts">
    import type { ItemCards } from "$lib/types/ItemCard";
    import { fetchNui } from "$utils/FetchNui";
    import { useNuiEvent } from "$utils/NuiEvents";
    import { Button, Card, Popover } from "flowbite-svelte";

    let open: boolean = true;
    let Items: ItemCards = [
        // {
        //     title: "Item",
        //     id: "1",
        //     image: "images/test.png",
        //     list: ["List item 1", "List item 2"]
        // }
    ];
    let other: any;

    useNuiEvent('open:itemContainer', function(data: any) {
        open = true;
        Items = data?.items || Items;
        other = data?.other || other;
    });

    function selectItem(index: number): void {
        if (!Items[index]) {
            return console.error("Item not found");
        }

        open = false;
        fetchNui('handle:itemContainer', {
            item: Items[index],
            other: other
        });
    }
    
    function closeTable(e: any) {
        if (!open) return;
        
        if (e.keyCode == 27) {
            open = false;
            fetchNui("close:itemContainer");
        }
    }
</script>

<svelte:window on:keydown={closeTable} />

{#if open}
    <center class="mt-[8rem]">
        <Card class="min-w-[64rem] max-h-[48rem] overflow-auto">
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                {#each Items as Item, index}
                    <div>
                        <Card img={Item?.image || ""} id="item-{index}" class="hover:cursor-pointer" size="xs">
                            <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">{Item.title}</h5>
                            {#if Item.description}
                                <p class="mb-3 font-normal text-gray-700 dark:text-gray-400 leading-tight">{Item.description}</p>
                            {/if}
                        </Card>
                        <Popover class="w-full sm:w-[12rem] text-sm font-light mt-32" title="Popover title" triggeredBy="#item-{index}" placement="bottom">
                            {#if Item?.list}
                                <div class="left-0">
                                    {#each Object.values(Item?.list) as listItem}
                                        <li>{listItem}</li>
                                    {/each}
                                </div>
                            {:else}
                                {Item.description || "No description"}
                            {/if}
                            <Button class="w-full sm:max-w-[12rem] mt-4" on:click={() => selectItem(index)}>Auswählen</Button>
                        </Popover>
                    </div>
                {/each}
                </div>
        </Card>
    </center>
{/if}