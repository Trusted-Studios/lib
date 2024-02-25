<script lang="ts">
    import type { ItemCards } from "$lib/types/ItemCard";
    import { fetchNui } from "$utils/FetchNui";
    import { useNuiEvent } from "$utils/NuiEvents";
    import { Button, Card, Popover } from "flowbite-svelte";

    let open: boolean = false;
    let Items: ItemCards = [
        {
            id: 'bread',
            title: 'Item1',
            list: ['Item1', 'Item2', 'Item3'],
        }
    ];
    let other: any;

    useNuiEvent('open:itemContainer', function(data: any) {
        open = true;
        Items = data?.items || Items;
        other = data?.other || other;

        console.log(Items)
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

    // Reactive statements
    $: console.log(Items);
    $: console.log(other);
</script>

{#if open}
    <center class="mt-[8rem]">
        <Card class="min-w-[64rem] max-h-[48rem] overflow-auto">
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                {#each Items as Item, index}
                    <div>
                        <Card img={Item?.image || ""} id="{Item.id}" class="hover:cursor-pointer" size="xs">
                            <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">{Item.title}</h5>
                            {#if Item.description}
                                <p class="mb-3 font-normal text-gray-700 dark:text-gray-400 leading-tight">{Item.description}</p>
                            {/if}
                        </Card>
                        <Popover class="transition ease-in-out delay-150 w-full sm:w-[12rem] text-sm font-light" title="Popover title" triggeredBy="#{Item.id}" defaultClass="py-5 px-6" placement={'bottom'}>
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